package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.CubeDetailsWindow;
	import com.muxxu.kube.common.components.ScrollbarKube;
	import com.muxxu.kube.kubebuilder.graphics.NextPageSignalGraphic;
	import com.muxxu.kube.kuberank.components.TileEngineItem;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.components.tile.TileEngine;
	import com.nurun.components.tile.events.TileEngineEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.math.MathUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * Displays the smooth list (draggable with progressive download)
	 * 
	 * @author Francois
	 */
	public class SmoothListView extends AbstractView {
		
		private var _engines:Vector.<TileEngine>;
		private var _lastVersion:Number;
		private var _pressed:Boolean;
		private var _offsetDrag:Number;
		private var _offsetMouseDrag:Number;
		private var _endScrollX:Number;
		private var _lastMousePos:Array;
		private var _scrollIncrement:Number;
		private var _opened:Boolean;
		private var _lastLength:uint;
		private var _emptyItem:CubeData;
		private var _scrollbar:ScrollbarKube;
		private var _scrollPressed:Boolean;
		private var _loadSignal:NextPageSignalGraphic;
		private var _lastSortType:Boolean;
		private var _details:CubeDetailsWindow;
		private var _rolledItem:TileEngineItem;
		private var _lastUserName:String;
		private var _wasTop3Mode:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SmoothListView</code>.
		 */
		public function SmoothListView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		override public function update(event:IModelEvent):void {
			TweenLite.killTweensOf(this);
			var model:ModelKR = event.model as ModelKR;
			if(!model.top3Mode) {
				var cantShowSignal:Boolean = _lastSortType != model.sortByDate || _lastUserName != model.userName;
				var resetChange:Boolean = cantShowSignal || _wasTop3Mode != model.top3Mode;
				var prevLength:int = _lastLength;
				if(resetChange) _lastLength = 0;
				if(model.data.version != _lastVersion) {
					//If already opened but new sort type, hide, populate then show back the view.
					if(_opened && resetChange) {
						TweenLite.to(this, .35, {x:-15, autoAlpha:0, ease:Sine.easeIn, onComplete:populate, onCompleteParams:[model.data, resetChange]});
						TweenLite.to(this, .35, {x:0, autoAlpha:1, delay:.5, ease:Sine.easeOut, onComplete:onShowComplete});
					}else{
						populate(model.data, resetChange);
					}
				}
				//if view is closed, show it.
				if(!_opened) {
					_opened = true;
					TweenLite.to(this, .25, {autoAlpha:1, delay:.5});
					stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
					addEventListener(Event.ENTER_FRAME, enterFrameHandler);
					_scrollbar.height = stage.stageWidth;
					_scrollbar.y = 400 + 13;
				}else if(model.data.version != _lastVersion && !cantShowSignal && model.data.length > prevLength){
					//If the view si already opened and if it's not a sort update
					//then display the load signal.
					_loadSignal.y = Math.round((400 - 100) * .5);
					_loadSignal.x = Math.round(stage.stageWidth - 100);
					TweenLite.to(_loadSignal, .5, {autoAlpha:1});
					TweenLite.to(_loadSignal, .5, {autoAlpha:0, delay:1});
				}
				_lastSortType = model.sortByDate;
				_lastUserName = model.userName;
				_lastVersion = model.data.version;
//				_lastLength = model.data.length;
				graphics.beginFill(0xff0000, 0);
				graphics.drawRect(0, 0, stage.stageWidth, _scrollbar.y);
				graphics.endFill();
			}else{
				//Close the view
				_opened = false;
				TweenLite.to(this, .25, {autoAlpha:0});
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			_wasTop3Mode = model.top3Mode;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			var i:int, len:int, engine:TileEngine;
			len = 3;
			_engines = new Vector.<TileEngine>(len, true);
			_endScrollX = 0;
			_emptyItem = new CubeData(i);
			_emptyItem.populate(new XML(Config.getVariable("defaultKube")).child("kube")[0]);
			
			for(i = 0; i < len; ++i) {
				engine = new TileEngine(TileEngineItem, 72, 130, 800, 70);
				engine.disableMask();
				addChild(engine);
				engine.y = i * 120 + 30;
				engine.x = 30;
				engine.addEventListener(TileEngineEvent.CLICK, clickCubeHandler);
				engine.addEventListener(TileEngineEvent.ROLL_OVER, mouseOverCubeHandler);
				engine.addEventListener(TileEngineEvent.ROLL_OUT, mouseOutCubeHandler);
				_engines[i] = engine;
			}
			
			_scrollbar = addChild(new ScrollbarKube(true)) as ScrollbarKube;
			_scrollbar.rotation = -90;
			_scrollbar.percent = .5;
			_scrollbar.scrollerMinSize = 400;
			
			_loadSignal = addChild(new NextPageSignalGraphic()) as NextPageSignalGraphic;
			_loadSignal.alpha = 0;
			_loadSignal.visible = false;
			_loadSignal.filters = [new DropShadowFilter(5, 135, 0, 1, 4, 4, .3, 3)];
			
			_details = new CubeDetailsWindow();
			
			_scrollIncrement = engine.widthItems + engine.hSpace;
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection, resetEngines:Boolean = false):void {
			var i:int, len:int, dataLen:int, engine:TileEngine;
			if(resetEngines) {
				_endScrollX = 0;
				_lastLength = 0;
				len = _engines.length;
				for(i = 0; i < len; ++i) {
					_engines[i].clear();
					_engines[i].offsetX = 0;
				}
			}
			
			dataLen = data.length;
			len = Math.ceil(dataLen/18) * 18;
			if(_lastLength != data.length) {
				for(i = _lastLength; i < len; ++i) {
					engine = _engines[i%3];
//					engine = _engines[Math.floor(i/6)%3];
					if(i >= dataLen) {
						engine.addItem(_emptyItem);
					}else{
						engine.addItem(data.getItemAt(i));
					}
				}
			}
			
			_lastLength = data.length;
		}
		
		/**
		 * Called when show tween completes.
		 * Juste ensure that the content will be visible
		 */
		private function onShowComplete():void {
			x = 0;
			alpha = 1;
			visible = true;
		}

		
		
		
		
		
		//__________________________________________________________ DRAG & DROP
		/**
		 * Called on ENTER_FRAME event to make the sliders scroll
		 */
		private function enterFrameHandler(event:Event):void {
			var i:int, len:int, engine:TileEngine;
			len = _engines.length;
			if(_pressed) {
				if(_lastMousePos.length > 3) _lastMousePos.shift();
				_lastMousePos.push(mouseX);
				_endScrollX = _offsetDrag + (mouseX-_offsetMouseDrag);
			}
			if(_scrollPressed) {
				_endScrollX -= (_scrollbar.percent - .5) * 200;
			}else if(Math.abs(_scrollbar.percent - .5) > .01){
				//Replaces the scroll continuously at the center
				_scrollbar.percent += (.5-_scrollbar.percent) * .1;
				_scrollbar.validate();
			}
			_endScrollX = Math.min(_engines[0].offsetXMax, Math.max(_endScrollX, _engines[0].offsetXMin));
			for(i = 0; i < len; ++i) {
				engine = _engines[i];
				if(Math.abs(engine.offsetX - _endScrollX) > 1) {
					engine.offsetX += (_endScrollX - engine.offsetX) * .3;
					engine.validate();
				}
			}
			
			var index:int = -Math.round((engine.offsetX - _scrollIncrement * 6) / _scrollIncrement)-1;
			FrontControlerKR.getInstance().setCurrentDisplayIndex(index * 3);
			
			if(_rolledItem != null) {
				_details.width = Math.round(_rolledItem.width * 3.5);
				_details.height = Math.round(_rolledItem.height);
				_details.x = Math.round(_rolledItem.x - _rolledItem.width * .15);
				_details.y = Math.round(_rolledItem.y - _rolledItem.height * .07);
				
				if(_details.x + _details.width + 50 > stage.stageWidth) {
					_details.displayLeft = true;
					_details.x = Math.round(_rolledItem.x + _rolledItem.width * 1.1 - _details.width);
				}else{
					_details.displayLeft = false;
				}
				_details.validate();
			}
		}
		
		/**
		 * Called when the mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			if(_scrollbar.contains(event.target as DisplayObject)) {
				_scrollPressed = true;
			}else if(contains(event.target as DisplayObject)) {
				_pressed = true;
				_offsetDrag = _engines[0].offsetX;
				_offsetMouseDrag = mouseX;
				_lastMousePos = [];
			}
		}
		
		/**
		 * Called when the mouse is released
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			if(_pressed) {
				var i:int, len:int, speed:Number;
				len = _lastMousePos.length;
				speed = 0;
				if(len > 0) {
					for(i = 1; i < len; ++i) {
						speed += _lastMousePos[i]-_lastMousePos[i-1];
					}
					speed /= len;
				}
				_endScrollX = Math.round((_endScrollX + speed * 15) / _scrollIncrement) * _scrollIncrement;
			}else if(_scrollPressed){
				_endScrollX = Math.round((_endScrollX) / _scrollIncrement) * _scrollIncrement;
			}
			_pressed = false;
			_scrollPressed = false;
		}
		
		/**
		 * Called when the user uses the mouse's wheel
		 */
		private function mouseWheelHandler(event:MouseEvent):void {
			_endScrollX += MathUtils.sign(event.delta) * (_engines[0].widthItems + _engines[0].hSpace);
		}
		
		
		
		
		
		//__________________________________________________________ CUBE MOUSE EVENTS
		
		/**
		 * Called when a cube is clicked
		 */
		private function clickCubeHandler(event:TileEngineEvent):void {
			FrontControlerKR.getInstance().openKube(event.item.getData() as CubeData);
		}
		
		/**
		 * Called when a cube is rolled over
		 */
		private function mouseOverCubeHandler(event:TileEngineEvent):void {
			_rolledItem = event.item as TileEngineItem;
			_rolledItem.parent.addChild(_details);
			_rolledItem.parent.addChild(_rolledItem);
			addChild(_rolledItem.parent.parent as TileEngine);
			addChild(_scrollbar);
			addChild(_loadSignal);
			
			TweenLite.killTweensOf(_details);
			_details.alpha = 1;
			_details.visible = true;
			_details.populate(_rolledItem.getData() as CubeData);
		}
		
		/**
		 * Called when a cube is rolled out.
		 */
		private function mouseOutCubeHandler(event:TileEngineEvent):void {
			if(_rolledItem == null) return;
			_rolledItem.parent.removeChild(_details);
			_rolledItem = null;
		}
		
	}
}