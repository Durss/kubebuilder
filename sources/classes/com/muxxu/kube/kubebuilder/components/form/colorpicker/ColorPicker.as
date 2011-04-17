package com.muxxu.kube.kubebuilder.components.form.colorpicker {
	import com.muxxu.kube.kubebuilder.components.buttons.ColorButton;
	import com.muxxu.kube.kubebuilder.components.form.KBInput;
	import com.muxxu.kube.kubebuilder.controler.FrontControler;
	import com.muxxu.kube.kubebuilder.graphics.ColorPickerGradientGraphic;
	import com.nurun.utils.color.ColorFunctions;
	import com.nurun.utils.pos.PosUtils;
	import com.nurun.utils.string.StringUtils;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ColorPicker extends Sprite {
		private var _gradient:ColorPickerGradientGraphic;
		private var _brightnessSelector:BrightnessSelector;
		private var _gradientCursor:Shape;
		private var _pressed:Boolean;
		private var _bmd:BitmapData;
		private var _hexInput:KBInput;
		private var _colorButtonsHolder:Sprite;
		private var _buttons:Vector.<ColorButton>;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ColorPicker</code>.
		 */
		public function ColorPicker() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



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
			_gradient = addChild(new ColorPickerGradientGraphic()) as ColorPickerGradientGraphic;
			_gradientCursor = addChild(new Shape()) as Shape;
			_brightnessSelector = addChild(new BrightnessSelector()) as BrightnessSelector;
			_hexInput = addChild(new KBInput("")) as KBInput;
			_colorButtonsHolder = addChild(new Sprite()) as Sprite;
			
			var i:int, len:int, bt:ColorButton;
			len = 12 * 4;
			_buttons = new Vector.<ColorButton>(len, true);
			var defaultColors:Array = [0, 0xffffff, 0xff0000, 0xff00ff, 0xffff00, 0x00ff00, 0x00ffff, 0x0000ff];
			for(i = 0; i < len; ++i) {
				bt = _colorButtonsHolder.addChild(new ColorButton(11,11)) as ColorButton;
				if(i < defaultColors.length) bt.color = defaultColors[i];
				_buttons[i] = bt;
			}
			PosUtils.hDistribute(_buttons, 190, 4, 2, true);
			
			_brightnessSelector.baseColor = 0xff0000;
			
			//Draw selection cursor
			_gradientCursor.graphics.beginFill(0, .5);
			_gradientCursor.graphics.drawRect(0, 0, 3, 1);
			_gradientCursor.graphics.drawRect(0, 1, 1, 1);
			_gradientCursor.graphics.drawRect(2, 1, 1, 1);
			_gradientCursor.graphics.drawRect(0, 2, 3, 1);
			_gradientCursor.graphics.endFill();
			
			_brightnessSelector.baseColor = 0xff0000;
			_hexInput.text = "#ff0000";
			_hexInput.textfield.maxChars = 7;
			_hexInput.textfield.restrict = "[0-9a-fA-F]#";
			
			//Position elements.
			_gradient.width = _gradient.height = _brightnessSelector.height = 150;
			_brightnessSelector.x = _gradient.width + 5;
			_brightnessSelector.width = 20;
			_hexInput.width = 75;
			_hexInput.validate();
			_hexInput.x = Math.round(176 - _hexInput.width);
			_hexInput.y = Math.round(_gradient.y + _gradient.height + 5);
			_colorButtonsHolder.y = Math.round(_hexInput.y + _hexInput.height + 5);
			
			var m:Matrix = new Matrix();
			m.scale(_gradient.scaleX, _gradient.scaleY);
			_bmd = new BitmapData(_gradient.width, _gradient.height, false, 0);
			_bmd.draw(_gradient, m);
			
			filters = [new GlowFilter(0,.6,2,2,1,3)];
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_brightnessSelector.addEventListener(Event.CHANGE, changeColorHandler);
			_brightnessSelector.addEventListener(Event.SELECT, selectColorHandler);
			_hexInput.addEventListener(Event.CHANGE, changeHexValueHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_gradient.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * Called when mouse moves.
		 */
		private function mouseMoveHandler(event:MouseEvent = null):void {
			if(_pressed) {
				_gradientCursor.x = mouseX - 1;
				_gradientCursor.y = mouseY - 1;
			}
			if(_gradientCursor.x < _gradient.x - 1) _gradientCursor.x = _gradient.x - 1;
			if(_gradientCursor.y < _gradient.y - 1) _gradientCursor.y = _gradient.y - 1;
			if(_gradientCursor.x > _gradient.x + _gradient.width - _gradientCursor.width + 1) _gradientCursor.x = _gradient.x + _gradient.width - _gradientCursor.width + 1;
			if(_gradientCursor.y > _gradient.y + _gradient.height - _gradientCursor.height + 1) _gradientCursor.y = _gradient.y + _gradient.height - _gradientCursor.height + 1;
			_brightnessSelector.baseColor = _bmd.getPixel(_gradientCursor.x - _gradient.x + 1, _gradientCursor.y - _gradient.y + 1);
			if(event != null) changeColorHandler();
		}
		
		/**
		 * Called when mouse is released.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			mouseMoveHandler(event);
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
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target is ColorButton) {
				var color:Number = ColorButton(event.target).color;
				if(!isNaN(color)) {
					updateFromColor(color);
					_hexInput.text = "#"+StringUtils.toDigit(color.toString(16), 6);
				}
			}
		}
		
		/**
		 * Called when the color changes.
		 */
		private function changeColorHandler(event:Event = null):void {
			_hexInput.text = "#"+_brightnessSelector.color.toString(16);
			FrontControler.getInstance().setCurrentColor(_brightnessSelector.color);
		}
		
		/**
		 * Called when a color is selected.
		 * Add it to the selection.
		 */
		private function selectColorHandler(event:Event):void {
			var i:int, len:int;
			len = _buttons.length;
			for(i = 0; i < len; ++i) {
				if(isNaN(_buttons[i].color)){
					_buttons[i].color = _brightnessSelector.color;
					break;
				}
			}
		}
		
		/**
		 * Called wehn hexadecimal value is changed manually.
		 */
		private function changeHexValueHandler(event:Event):void {
			var color:uint = parseInt(_hexInput.text.replace(/#/gi, ""), 16);
			if(!isNaN(color)) updateFromColor(color);
		}
		
		/**
		 * Updates the selectors from a color.
		 */
		private function updateFromColor(color:uint):void {
			_gradientCursor.y = Math.round((1 - ColorFunctions.getSaturation(color) / ColorFunctions.SMAX) * _gradient.height - 1);
			_gradientCursor.x = Math.round((ColorFunctions.getHue(color) / ColorFunctions.HMAX) * _gradient.width - 1);
			//Probably due to a computation problem the getHue method may
			//return a negativ value. In that case we just loop this value to
			//the other side of the gradient.
			if(_gradientCursor.x < 0) _gradientCursor.x = _gradient.width + _gradientCursor.x;
			_brightnessSelector.luminosity = ColorFunctions.getLuminosity(color) / ColorFunctions.LMAX;
			mouseMoveHandler();
			FrontControler.getInstance().setCurrentColor(color);
		}
		
	}
}