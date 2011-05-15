package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Linear;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.CubeDetailsWindow;
	import com.muxxu.kube.kubebuilder.graphics.PodiumGraphic;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.components.button.events.NurunButtonEvent;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	/**
	 * Displays the TOP 3 of the rank.
	 * 
	 * @author Francois
	 */
	public class Top3View extends AbstractView {
		
		private var _podium:PodiumGraphic;
		private var _cubes:Vector.<CubeResult>;
		private var _lastVersion:Number;
		private var _details:CubeDetailsWindow;
		private var _rolledItem:CubeResult;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Top3View</code>.
		 */
		public function Top3View() {
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
			var i:int, len:int;
			var model:ModelKR = event.model as ModelKR;
			
			if(model.top3Mode) {
				if(model.data.version == _lastVersion) return;
				_lastVersion = model.data.version;
				populate(model.data);
				TweenLite.to(this, .25, {autoAlpha:1});
				TweenLite.to(_podium, .5, {frame:_podium.totalFrames, delay:.25, ease:Sine.easeInOut});
				TweenLite.to(_podium._maskMc, .5, {frame:_podium._maskMc.totalFrames, delay:.25, ease:Sine.easeInOut});
				TweenMax.to(_podium, 2, {ease:Linear.easeNone, yoyo:0, dropShadowFilter:{distance:50, blurY:50, alpha:.25, index:0}});
			}else{
				TweenLite.killTweensOf(this);
				TweenLite.killTweensOf(_podium);
				TweenLite.killTweensOf(_podium._maskMc);
				len = _cubes.length;
				for(i = 0; i < len; ++i) {
					_cubes[i].alpha = 1;
					_cubes[i].visible = true;
					_cubes[i].stopAllAnimations();
					TweenLite.killTweensOf(_cubes[i]);
				}
				TweenLite.to(this, .25, {autoAlpha:0, delay:.25});
				TweenLite.to(_podium, .5, {frame:1, ease:Sine.easeInOut});
				TweenLite.to(_podium._maskMc, .5, {frame:1, ease:Sine.easeInOut});
				for(i = 0; i < len; ++i) {
					TweenLite.to(_cubes[i], .5, {y:"-50", autoAlpha:0, delay:(len-i)*.1, ease:Sine.easeInOut});
				}
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			alpha = 0;
			visible = false;
			
			_details = new CubeDetailsWindow();
			_podium = addChild(new PodiumGraphic()) as PodiumGraphic;
			_podium.filters = [new DropShadowFilter(20,270,0xffffff,.1,0,20,1,2)];
			
			_podium.stop();
			_podium._maskMc.stop();
							
			var i:int, len:int, cube:CubeResult;
			len = 3;
			_cubes = new Vector.<CubeResult>(len, true);
			for(i = 0; i < len; ++i) {
				cube = addChildAt(new CubeResult(), 1) as CubeResult;
				_cubes[i] = cube;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(NurunButtonEvent.CLICK, clickCubeHandler);
			addEventListener(NurunButtonEvent.OVER, mouseOverCubeHandler);
			addEventListener(NurunButtonEvent.OUT, mouseOutCubeHandler);
			addEventListener(NurunButtonEvent.RELEASE_OUTSIDE, mouseOutCubeHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			x = Math.round((stage.stageWidth - _podium.width) * .5);
			y = 135;
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection):void {
			var i:int, len:int, start:Point;
			var positions:Array = [new Point(270, -30), new Point(100, 15), new Point(430, 70)];
			var sizes:Array = [77, 66, 55];
			len = 3;
			for(i = 0; i < len; ++i) {
				start = Point(positions[i]).clone();
				start.y = -250;
				_cubes[i].alpha = 1;
				_cubes[i].visible = true;
				_cubes[i].populate(data.getItemAt(i), start, positions[i], sizes[i], i + 2);
				TweenLite.killDelayedCallsTo(_cubes[i].doOpeningTransition);
				TweenLite.delayedCall((3-i)*.5, _cubes[i].doOpeningTransition, [(len-i)*.5 - (3-i)*.5]);
			}
			computePositions();
		}
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when a cube is clicked
		 */
		private function clickCubeHandler(event:NurunButtonEvent):void {
			if(!(event.target is CubeResult)) return;
			FrontControlerKR.getInstance().openKube((event.target as CubeResult).data);
		}
		
		/**
		 * Called when a component is rolled over
		 */
		private function mouseOverCubeHandler(event:NurunButtonEvent):void {
			if(!(event.target is CubeResult)) return;
			_rolledItem = event.target as CubeResult;
			addChild(_details);
			addChild(_rolledItem);
			
			TweenLite.killTweensOf(_details);
			_details.alpha = 1;
			_details.visible = true;
			_details.populate(_rolledItem.data);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			enterFrameHandler();
		}
		
		/**
		 * Called when a component is rolled out.
		 */
		private function mouseOutCubeHandler(event:NurunButtonEvent):void {
			_rolledItem = null;
			
			TweenLite.to(_details, .25, {autoAlpha:0, width:_details.width*.9, height:_details.height*.9, onUpdate:_details.validate, removeChild:true});
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Called on ENTER_FRAME event to place the details behind the rolled kube.
		 */
		private function enterFrameHandler(event:Event = null):void {
			_details.height = Math.round(_rolledItem.height * 1.6);
			_details.width = Math.round(_rolledItem.width * 1.6 + 170);
			_details.x = Math.max(-x, Math.round(_rolledItem.x - _rolledItem.width * .8));
			_details.y = Math.max(-y, Math.round(_rolledItem.y - _rolledItem.height * .8));
			
			if(_details.x + _details.width > stage.stageWidth) {
				_details.displayLeft = true;
				_details.x = Math.round(_rolledItem.x + _rolledItem.width * .8 - _details.width);
			}else{
				_details.displayLeft = false;
			}
			_details.validate();
		}
		
	}
}