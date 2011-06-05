package com.muxxu.kube.kuberank.components {
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.components.button.BaseButton;
	import com.nurun.components.volume.Cube;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * Creates a cube icon for a BaseButton instance.
	 * 
	 * @author Francois
	 */
	public class CubeButtonIcon extends Sprite {
		
		private var _ba:ByteArray;
		private var _cube:Cube;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeButtonIcon</code>.
		 */
		public function CubeButtonIcon(ba:ByteArray) {
			_ba = ba;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the width of the component.
		 */
		override public function get width():Number { return _cube.width; }
		
		/**
		 * Gets the height of the component.
		 */
		override public function get height():Number { return _cube.height; }



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			mouseChildren = false;
			_cube = addChild(new Cube()) as Cube;
			_cube.width = _cube.height = _cube.depth = 32;
			var data:KUBData = new KUBData();
			data.fromByteArray(_ba);
			_cube.leftFace = new CubeFace(data.faceSides);
			_cube.rightFace = new CubeFace(data.faceSides);
			_cube.frontFace = new CubeFace(data.faceSides);
			_cube.backFace = new CubeFace(data.faceSides);
			_cube.topFace = new CubeFace(data.faceTop);
			_cube.bottomFace = new CubeFace(data.faceBottom);
			_cube.x = _cube.width * .5;
			_cube.y = _cube.height * .5;
			_cube.validate();
			
			//Hit bounds to prevent from rollout when mouse is on a edge of the cube.
			graphics.beginFill(0xff0000, 0);
			graphics.drawRect(0, 0, _cube.width, _cube.height);
			graphics.endFill();

			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0,0);
			_cube.transform.perspectiveProjection = pp;
			
			addEventListener(Event.ADDED, addedHandler);
		}
		
		/**
		 * Called when the component is added to a container.
		 */
		private function addedHandler(event:Event):void {
			removeEventListener(Event.ADDED, addedHandler);
			if(parent is BaseButton) {
				parent.addEventListener(MouseEvent.ROLL_OVER, rollOverKubeHandler);
				parent.addEventListener(MouseEvent.ROLL_OUT, rollOutKubeHandler);
			}else{
				buttonMode = true;
				addEventListener(MouseEvent.ROLL_OVER, rollOverKubeHandler);
				addEventListener(MouseEvent.ROLL_OUT, rollOutKubeHandler);
			}
		}
		
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when vote button is rolled over.
		 */
		private function rollOverKubeHandler(event:MouseEvent):void {
			TweenLite.to(_cube, .25, {rotationX:90, ease:Sine.easeInOut, onUpdate:_cube.validate});
		}

		/**
		 * Called when vote button is rolled out.
		 */
		private function rollOutKubeHandler(event:MouseEvent):void {
			TweenLite.to(_cube, .25, {rotationX:0, ease:Sine.easeInOut, onUpdate:_cube.validate});
		}	
		
	}
}