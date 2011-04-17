package com.muxxu.kube.kubebuilder.views {
	import com.muxxu.kube.kubebuilder.components.cube.CubeFace;
	import com.muxxu.kube.kubebuilder.model.Model;
	import com.nurun.components.volume.Cube;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 */
	public class KubeView extends AbstractView {
		private var _kube:Cube;
		private var _initialized:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeView</code>.
		 */
		public function KubeView() {
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
			var model:Model = event.model as Model;
			if(!_initialized) {
				_initialized = true;
				_kube.leftFace = new CubeFace(model.kubeData.faceSides);
				_kube.rightFace = new CubeFace(model.kubeData.faceSides);
				_kube.frontFace = new CubeFace(model.kubeData.faceSides);
				_kube.backFace = new CubeFace(model.kubeData.faceSides);
				_kube.topFace = new CubeFace(model.kubeData.faceTop); 
				_kube.bottomFace = new CubeFace(model.kubeData.faceBottom);
			} 
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_kube = addChild(new Cube()) as Cube;
			_kube.width = _kube.height = _kube.depth = 200;

			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_kube.transform.perspectiveProjection = pp;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function enterFrameHandler(event:Event):void {
			_kube.rotationX += 5;
			_kube.rotationY += 5;
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
			x = stage.stageWidth - _kube.width;
			y = stage.stageHeight * .5;
		}
		
	}
}