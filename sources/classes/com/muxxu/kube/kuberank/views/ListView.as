package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.CubeDetailsWindow;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.components.button.events.NurunButtonEvent;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ListView extends AbstractView {
		private var _lastVersion:Number;
		private var _cubes:Vector.<CubeResult>;
		private var _rolledItem:CubeResult;
		private var _details:CubeDetailsWindow;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListView</code>.
		 */
		public function ListView() {
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
			var model:ModelKR = event.model as ModelKR;
			if(!model.top3Mode) {
				if(model.data.version == _lastVersion) return;
				_lastVersion = model.data.version;
				TweenLite.to(this, .25, {autoAlpha:1});
				populate(model.data);
			}else{
				TweenLite.to(this, .25, {autoAlpha:0});
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_details = new CubeDetailsWindow();
			var i:int, len:int;
			len = 6 * 3;
			_cubes = new Vector.<CubeResult>(len, true);
			for(i = 0; i < len; ++i) {
				_cubes[i] = new CubeResult();
			}
			
			alpha = 0;
			visible = false;
			addEventListener(NurunButtonEvent.CLICK, clickCubeHandler);
			addEventListener(NurunButtonEvent.OVER, mouseOverCubeHandler);
			addEventListener(NurunButtonEvent.OUT, mouseOutCubeHandler);
			addEventListener(NurunButtonEvent.RELEASE_OUTSIDE, mouseOutCubeHandler);
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection):void {
			var i:int, len:int, dataLen:int, cube:CubeResult;
			len = _cubes.length;
			dataLen = data.length;
			for(i = 0; i < len; ++i) {
				cube = _cubes[i];
				if(i < dataLen) {
					cube.x = (i%6) * 140 + 85;
					cube.y = Math.floor(i/6) * 130 + 70;
					cube.populate(data.getItemAt(i), new Point(cube.x, -200), new Point(cube.x, cube.y), 75);
					TweenLite.killDelayedCallsTo(cube.doOpeningTransition);
					TweenLite.delayedCall(i*.2, cube.doOpeningTransition, [(dataLen-i+1)*.2]);
					addChild(cube);
				}else{
					if(contains(cube)) removeChild(cube);
				}
			}
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
			_details.populate(_rolledItem.data);
			
			_details.height = Math.round(_rolledItem.height * .8 * 2);
			_details.width = Math.round(_rolledItem.width * 3.5);
			_details.x = Math.max(0, Math.round(_rolledItem.x - _rolledItem.width * .8));
			_details.y = Math.max(0, Math.round(_rolledItem.y - _rolledItem.height * .8));
			
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