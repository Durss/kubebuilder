package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.BackWindow;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 */
	public class SingleKubeView extends AbstractView {
		private var _data:CubeData;
		private var _cube:CubeResult;
		private var _background:BackWindow;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SingleKubeView</code>.
		 */
		public function SingleKubeView() {
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
			_data = model.openedCube;
			if(_data != null) {
				populate();
				TweenLite.to(this, .25, {autoAlpha:1});
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
			alpha = 0;
			visible = false;
			_background = addChild(new BackWindow()) as BackWindow;
			_cube = addChild(new CubeResult()) as CubeResult;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
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
			_background.width = 700;
			_background.height = 300;
			x = Math.round((stage.stageWidth - _background.width) * .5);
			y = Math.round((stage.stageHeight - _background.height) * .5);
		}
		
		/**
		 * Populates the component
		 */
		private function populate():void {
			var endPos:Point = new Point(150, _background.height * .5);
			var startPos:Point = endPos.clone();
			startPos.y = -300;
			_cube.populate(_data, startPos, endPos, 150);
			_cube.doOpeningTransition();
			
			computePositions();
		}
		
	}
}