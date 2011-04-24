package com.muxxu.kube.kubebuilder.components.panel {
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import com.muxxu.kube.kubebuilder.vo.ToolType;
	import flash.utils.Dictionary;
	import com.nurun.components.form.events.FormComponentGroupEvent;
	import com.nurun.components.form.FormComponentGroup;
	import com.muxxu.kube.kubebuilder.components.buttons.KBButton;
	import com.muxxu.kube.kubebuilder.components.buttons.ToolButton;
	import com.muxxu.kube.kubebuilder.components.form.colorpicker.ColorPicker;
	import com.muxxu.kube.kubebuilder.controler.FrontControler;
	import com.muxxu.kube.kubebuilder.graphics.PaintBucketGraphic;
	import com.muxxu.kube.kubebuilder.graphics.PencilGraphic;
	import com.muxxu.kube.kubebuilder.graphics.PipetteGraphic;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	/**
	 * 
	 * @author Francois
	 */
	public class PanelToolsContent extends Sprite {
		private var _copyBt:KBButton;
		private var _pastBt:KBButton;
		private var _resetBt:KBButton;
		private var _fileBt:KBButton;
		private var _colorPicker:ColorPicker;
		private var _pipetteBt:ToolButton;
		private var _paintBucketBt:ToolButton;
		private var _pencilBt:ToolButton;
		private var _group:FormComponentGroup;
		private var _buttonToToolId:Dictionary;
		private var _exportBt:KBButton;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PanelToolsContent</code>.
		 */
		public function PanelToolsContent() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		public function set color(value:uint):void {
			_colorPicker.color = value;
			changeColorHandler();
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
			_group = new FormComponentGroup();
			
			_copyBt = addChild(new KBButton(Label.getLabel("copy"))) as KBButton;
			_pastBt = addChild(new KBButton(Label.getLabel("past"))) as KBButton;
			_resetBt = addChild(new KBButton(Label.getLabel("raz"))) as KBButton;
			_fileBt = addChild(new KBButton(Label.getLabel("image"))) as KBButton;
			_exportBt = addChild(new KBButton(Label.getLabel("exportImage"))) as KBButton;
			_pencilBt = addChild(new ToolButton(new PencilGraphic())) as ToolButton;
			_pipetteBt = addChild(new ToolButton(new PipetteGraphic())) as ToolButton;
			_paintBucketBt = addChild(new ToolButton(new PaintBucketGraphic())) as ToolButton;
			
			_group.add(_pencilBt);
			_group.add(_pipetteBt);
			_group.add(_paintBucketBt);
			
			_buttonToToolId = new Dictionary();
			_buttonToToolId[_pencilBt] = ToolType.PENCIL;
			_buttonToToolId[_paintBucketBt] = ToolType.PAINT_BUCKET;
			_buttonToToolId[_pipetteBt] = ToolType.PIPETTE;
			
			_pencilBt.selected = true;
			
			_colorPicker = addChild(new ColorPicker()) as ColorPicker;
			
			_copyBt.width = 56;
			_pastBt.width = 56;
			_resetBt.width = 56;
			_fileBt.width = 56;
			_exportBt.width = 56 * 2 + 4;
			
			computePositions();
			addEventListener(MouseEvent.CLICK, clickHandler);
			_colorPicker.addEventListener(Event.CHANGE, changeColorHandler);
			_group.addEventListener(FormComponentGroupEvent.CHANGE, changeToolHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			PosUtils.hDistribute([_copyBt, _pastBt, _resetBt, _fileBt], 190, 4, 4, true);
			_exportBt.x = Math.round(_fileBt.x + _fileBt.width + 4);
			_exportBt.y = _fileBt.y;
			
			//Draw dotted line
			var i:int, len:int, lineWidth:int, py:int;
			py = _fileBt.y + _fileBt.height + 10;
			lineWidth = 7;
			len = 190 / (lineWidth * 2);
			graphics.beginFill(0xffffff, 1);
			for(i = 0; i < len; i++) graphics.drawRect(i*lineWidth*2, py, lineWidth, 1);
			
			_colorPicker.y = py + 10;
			
			_pencilBt.y = _paintBucketBt.y = _pipetteBt.y = _colorPicker.y + 155;
			PosUtils.hPlaceNext(10, _pencilBt, _paintBucketBt, _pipetteBt);
		}
		
		/**
		 * Called when a new color is selected.
		 */
		private function changeColorHandler(event:Event = null):void {
			var ct:ColorTransform = new ColorTransform();
			ct.color = _colorPicker.color;
			PencilGraphic(_pencilBt.icon)._colorMc.transform.colorTransform = ct;
			PipetteGraphic(_pipetteBt.icon)._colorMc.transform.colorTransform = ct;
			PaintBucketGraphic(_paintBucketBt.icon)._colorMc.transform.colorTransform = ct;
			
			if(event != null) {
				FrontControler.getInstance().setCurrentColor(_colorPicker.color);
			}
		}
		
		/**
		 * Called when the user selects a new tool.
		 */
		private function changeToolHandler(event:FormComponentGroupEvent):void {
			FrontControler.getInstance().setToolType(_buttonToToolId[event.selectedItem]);
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			var target:DisplayObject = event.target as DisplayObject;
			if(target == _fileBt) {
				FrontControler.getInstance().loadFile();
			}else if(target == _resetBt) {
				FrontControler.getInstance().reset();
			}else if(target == _copyBt) {
				FrontControler.getInstance().copy();
			}else if(target == _pastBt) {
				FrontControler.getInstance().past();
			}else if(target == _exportBt) {
				FrontControler.getInstance().exportFace();
			}
		}
		
		/**
		 * Called when a key is released.
		 */
		private function keyUpHandler(event:KeyboardEvent):void {
			if(event.ctrlKey) {
				if(event.keyCode == Keyboard.C) {
					FrontControler.getInstance().copy();
				}else if(event.keyCode == Keyboard.V) {
					FrontControler.getInstance().past();
				}
			}else{
				if(event.keyCode == Keyboard.P || event.keyCode == Keyboard.ESCAPE) {
					_pipetteBt.selected  = true;
				}else if(event.keyCode == Keyboard.V || event.keyCode == Keyboard.C) {
					_pencilBt.selected  = true;
				}else if(event.keyCode == Keyboard.B) {
					_paintBucketBt.selected  = true;
				}
			}
		}
		
	}
}