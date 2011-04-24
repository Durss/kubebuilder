package com.muxxu.kube.common.components.cube {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Creates a cube's face.
	 * 
	 * @author Francois
	 */
	public class CubeFace extends Sprite {
		
		private var _height:Number;
		private var _width:Number;
		private var _bmp:Bitmap;
		private var _bmd:BitmapData;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeFace</code>.
		 */
		public function CubeFace(bmd:BitmapData) {
			_bmd = bmd;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Sets the width of the component without simply scaling it.
		 */
		override public function set width(value:Number):void {
			_width = value;
			computePositions();
		}
		
		/**
		 * Sets the height of the component without simply scaling it.
		 */
		override public function set height(value:Number):void {
			_height = value;
			computePositions();
		}



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
			_width = _height = 16;
			_bmp = addChild(new Bitmap(_bmd)) as Bitmap;
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_bmp.width = _width;
			_bmp.height = _height;
			_bmp.x = -_width * .5;
			_bmp.y = -_height * .5;
		}
		
	}
}