package com.muxxu.kube.kuberank.components {
	import gs.TweenLite;
	import gs.easing.Quad;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.kubebuilder.graphics.WingGraphic;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.volume.Cube;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * Creates a result cube
	 * 
	 * @author Francois
	 */
	public class CubeResult extends Sprite {
		
		private var _startPos:Point;
		private var _endPos:Point;
		private var _cube:Cube;
		private var _data:CubeData;
		private var _wingLeft:WingGraphic;
		private var _wingRight:WingGraphic;
		private var _size:int;
		private var _endRX:int;
		private var _endRY:int;
		private var _pressed:Boolean;
		private var _rotationOffsets:Point;
		private var _mouseOffset:Point;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeResult</code>.
		 */
		public function CubeResult(data:CubeData, startPos:Point, endPos:Point, size:int = 70) {
			_size = size;
			_data = data;
			_endPos = endPos;
			_startPos = startPos;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Does the opening transition.
		 */
		public function doOpenTransition():void {
			TweenLite.to(_cube, 1.5, {ease:Quad.easeOut, y:_endPos.y, x:_endPos.x});
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_cube = addChild(new Cube()) as Cube;
			_wingLeft = new WingGraphic();
			_wingRight = new WingGraphic();
			
			_cube.leftFace = new CubeFace(_data.kub.faceSides);
			_cube.rightFace = new CubeFace(_data.kub.faceSides);
			_cube.frontFace = new CubeFace(_data.kub.faceSides);
			_cube.backFace = new CubeFace(_data.kub.faceSides);
			_cube.topFace = new CubeFace(_data.kub.faceTop); 
			_cube.bottomFace = new CubeFace(_data.kub.faceBottom);
			
			_cube.width = _cube.height = _cube.depth = _size;
			_wingRight.scaleX = -1;
			_wingLeft.x = -_cube.width * .5;
			_wingRight.x = _cube.width * .5;
			
			_endRX = 40;
			_endRY = 45;
			
			x = _startPos.x;
			y = _startPos.y;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_cube.transform.perspectiveProjection = pp;
			
			_cube.doubleClickEnabled = true;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Called when mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_rotationOffsets = new Point(_cube.rotationX, _cube.rotationY);
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
			_cube.rotationX += (_endRX - _cube.rotationX) * .1;
			_cube.rotationY += (_endRY - _cube.rotationY) * .1;
			_cube.validate();
		}
		
	}
}