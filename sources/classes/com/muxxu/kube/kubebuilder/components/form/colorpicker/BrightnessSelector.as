package com.muxxu.kube.kubebuilder.components.form.colorpicker {
	import com.nurun.utils.color.ColorFunctions;
	import com.nurun.utils.math.MathUtils;

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	 * Fired when the color square is clicked.
	 */
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * Fired when the brightness is changed.
	 */
	[Event(name="change", type="flash.events.Event")]
	
	
	/**
	 * 
	 * @author Francois
	 */
	public class BrightnessSelector extends Sprite {
		
		private var _pressed:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _baseColor:uint;
		private var _bmd:BitmapData;
		private var _color:uint;
		private var _previousColor:uint;
		private var _lastCursorPos:Number;
		private var _fireChange:Boolean;
		private var _colorBt:Sprite;
		private var _gradientH:Number;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>BrightnessSelector</code>.
		 */
		public function BrightnessSelector() {
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
			if(_bmd != null) _bmd.dispose();
			_bmd = new BitmapData(_width, _height, false,0);
			render();
		}
		
		/**
		 * Sets the height of the component without simply scaling it.
		 */
		override public function set height(value:Number):void {
			_height = value;
			if(_bmd != null) _bmd.dispose();
			_bmd = new BitmapData(_width, _height, false,0);
			render();
		}
		
		/**
		 * Sets the selected color.
		 */
		public function set color(value:uint):void {
			_lastCursorPos = _gradientH - (ColorFunctions.getLuminosity(value) / ColorFunctions.LMAX) * _gradientH;
			_color = value;
			_fireChange = false;
			render();
			_fireChange = true;
		}
		
		/**
		 * Gets the selected color.
		 */
		public function get color():uint { return _color; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		
		/**
		 * Sets the base color of the gradient.
		 */
		public function setBaseColor(value:uint, fireChange:Boolean = true):void {
			_baseColor = value;
			_fireChange = fireChange;
			render();
			_fireChange = true;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_colorBt = addChild(new Sprite()) as Sprite;
			_colorBt.buttonMode = true;
			
			_baseColor = 0;
			_width = 20;
			_height = 200;
			_bmd = new BitmapData(_width, _height, false,0);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_colorBt.addEventListener(MouseEvent.CLICK, clickColorHandler);
		}
		
		/**
		 * Called when the color square is clicked.
		 */
		private function clickColorHandler(event:MouseEvent):void {
			dispatchEvent(new Event(Event.SELECT));
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * Called when mouse moves.
		 */
		private function mouseMoveHandler(event:MouseEvent):void {
			render();
		}
		
		/**
		 * Called when mouse is released.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			if(event.target == _colorBt) return;
			_pressed = true;
			render();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		/**
		 * Called when mouse is pressed.
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			_pressed = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * Renders the component
		 */
		private function render():void {
			_gradientH = _height - _width - 5;
			var m:Matrix = new Matrix();
			m.createGradientBox(_width, _gradientH, Math.PI/180*90);
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, _baseColor, 0], [1,1,1], [0,0xff*.5, 0xff], m);
			graphics.drawRect(0,0,_width,_gradientH);
			graphics.endFill();
			
			if(_pressed)				_lastCursorPos = MathUtils.restrict(mouseY, 0, _gradientH);
			if(isNaN(_lastCursorPos))	_lastCursorPos = _gradientH * .5;
			
			graphics.beginFill(0,1);
			graphics.moveTo(_width, _lastCursorPos);
			graphics.lineTo(_width + 7, _lastCursorPos-5);
			graphics.lineTo(_width + 7, _lastCursorPos+5);
			graphics.lineTo(_width, _lastCursorPos);
			graphics.endFill();
			
			_bmd.draw(this);
			if(_fireChange) _color = _bmd.getPixel(1, _lastCursorPos);
			if(_color != _previousColor && _fireChange) {
				dispatchEvent(new Event(Event.CHANGE));
			}
			_previousColor = _color;
			_colorBt.y = _gradientH + 5;
			_colorBt.graphics.clear();
			_colorBt.graphics.beginFill(_color);
			_colorBt.graphics.drawRect(0, 0, _width, _width);
			_colorBt.graphics.endFill();
		}
		
	}
}