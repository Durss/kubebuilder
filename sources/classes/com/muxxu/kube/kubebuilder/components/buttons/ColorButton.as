package com.muxxu.kube.kubebuilder.components.buttons {
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import com.nurun.components.button.AbstractNurunButton;
	
	/**
	 * Displays a color button.
	 * Used by the color picker.
	 * 
	 * @author Francois
	 */
	public class ColorButton extends AbstractNurunButton {
		
		private var _height:Number;
		private var _width:Number;
		private var _color:Number;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ColorButton</code>.
		 */
		public function ColorButton(width:int, height:int) {
			_width = width;
			_height = height;
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
			render();
		}
		
		/**
		 * Sets the height of the component without simply scaling it.
		 */
		override public function set height(value:Number):void {
			_height = value;
			render();
		}
		
		/**
		 * Gets the component's color
		 */
		public function get color():Number { return _color; }
		
		/**
		 * Sets the component's color
		 */
		public function set color(color:Number):void { _color = color; render(); }




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
			render();
		}
		
		/**
		 * Renders the component
		 */
		private function render():void {
			graphics.beginFill(0x999999, 1);
			graphics.drawRect(0, 0, _width, 1);
			graphics.drawRect(_width-1, 1, 1, _height - 1);
			graphics.drawRect(0, 1, 1, _height-1);
			graphics.drawRect(1, _height - 2, _width - 2, 1);
			graphics.endFill();
			
			if(isNaN(_color) || color == uint.MAX_VALUE) {
				graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0xE1E1E1], [1,1], [0,0xff]);
				var m:Matrix = new Matrix();
				m.createGradientBox(_width - 2, _height - 2);
				graphics.drawRect(1, 1, width-2, height-2);
				if(color == uint.MAX_VALUE) {
					graphics.lineStyle(0,0xff0000,1);
					graphics.moveTo(2, 2);
					graphics.lineTo(_width - 2, _height -2);
					graphics.moveTo(_width - 2, 2);
					graphics.lineTo(2, _height -2);
				}
			}else{
				graphics.beginFill(_color, 1);
				graphics.drawRect(1, 1, width-2, height-2);
			}
			
			graphics.endFill();
		}
		
	}
}