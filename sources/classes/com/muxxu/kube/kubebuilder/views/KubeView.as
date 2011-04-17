package com.muxxu.kube.kubebuilder.views {
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
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
		private var _rotationOffsets:Point;
		private var _mouseOffset:Point;
		private var _pressed:Boolean;
		private var _endRX:Number;
		private var _endRY:Number;
		
		
		
		
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
			
			_endRX = _endRY = 0;
			
			filters = [new DropShadowFilter(0,0,0,.25,20,20,1,3)];
			
			_endRX = 40;
			_endRY = 45;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_kube.transform.perspectiveProjection = pp;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			x = stage.stageWidth - _kube.width + 20;
			y = stage.stageHeight * .5;
		}
		
		/**
		 * Called when mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_rotationOffsets = new Point(_kube.rotationX, _kube.rotationY);
			_mouseOffset = new Point(mouseX, mouseY);
		}

		/**
		 * Called when mouse is released.
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			_pressed = false;
		}
		
		/**
		 * Called on ENTER_FRAME event.
		 */
		private function enterFrameHandler(event:Event):void {
			if(_pressed) {
				_endRX = _rotationOffsets.x - (_mouseOffset.y - mouseY);
				_endRY = _rotationOffsets.y + (_mouseOffset.x - mouseX);
			}
			_kube.rotationX += (_endRX - _kube.rotationX) * .1;
			_kube.rotationY += (_endRY - _kube.rotationY) * .1;
			_kube.validate();
		}
		
	}
}