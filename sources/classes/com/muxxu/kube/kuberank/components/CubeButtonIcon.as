package com.muxxu.kube.kuberank.components {
	import gs.TweenLite;
	import gs.easing.Bounce;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.components.volume.Cube;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			
			addEventListener(Event.ADDED, addedHandler);
		}
		
		/**
		 * Called when the component is added to a container.
		 */
		private function addedHandler(event:Event):void {
			removeEventListener(Event.ADDED, addedHandler);
			parent.addEventListener(MouseEvent.ROLL_OVER, rollOverKubeHandler);
			parent.addEventListener(MouseEvent.ROLL_OUT, rollOutKubeHandler);
		}
		
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when vote button is rolled over.
		 */
		private function rollOverKubeHandler(event:MouseEvent):void {
			TweenLite.to(_cube, .75, {rotationX:90, ease:Bounce.easeOut, onUpdate:_cube.validate});
		}

		/**
		 * Called when vote button is rolled out.
		 */
		private function rollOutKubeHandler(event:MouseEvent):void {
			TweenLite.to(_cube, .75, {rotationX:0, ease:Bounce.easeOut, onUpdate:_cube.validate});
		}	
		
	}
}