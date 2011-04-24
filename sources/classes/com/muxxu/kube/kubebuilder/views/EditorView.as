package com.muxxu.kube.kubebuilder.views {
	import com.nurun.utils.color.ColorFunctions;
	import gs.TweenLite;

	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.muxxu.kube.kubebuilder.model.ModelKB;
	import com.muxxu.kube.kubebuilder.vo.ToolType;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	/**
	 * Displays the editor's grid.
	 * 
	 * @author Francois
	 */
	public class EditorView extends AbstractView {
		
		private const _CELL_SIZE:int = 20;
		
		private var _grid:Shape;
		private var _bmp:Bitmap;
		private var _color:uint;
		private var _tool:String;
		private var _history:Vector.<BitmapData>;
		private var _historyPointer:int;
		private var _bitmapModified:Boolean;
		private var _oldFace:BitmapData;
		private var _facesHistory:Dictionary;
		private var _highlight:Shape;
		private var _pressed:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>EditorView</code>.
		 */
		public function EditorView() {
			super();
			initialize();
			ViewLocator.getInstance().setViewPriority(this, 1);
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
			var model:ModelKB = event.model as ModelKB;
			_bmp.bitmapData = model.currentFace;
			//If selected face has changed.
			if(model.currentFace != _oldFace) {
				//Saves the history of the previous face
				if(_history != null) {
					_facesHistory[_oldFace] = [_history, _historyPointer];
				}
				//Loads the history of the new face
				_oldFace = model.currentFace;
				if(_facesHistory[_oldFace] == null) {
					//If no history yet, create one.
					_history = new Vector.<BitmapData>();
					_history.push(_oldFace.clone());
					_historyPointer = 0;
				}else{
					//If an history exists, load it.
					_history = _facesHistory[_oldFace][0];
					_historyPointer = _facesHistory[_oldFace][1];
				}
			}
			
			if(model.imageModified) {
				addImageToHistory();
			}
			
			if(model.kubeSubmitted) {
				TweenLite.to(this, .25, {autoAlpha:0});
			}
			
			_color = model.color;
			_tool = model.tool;
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_bmp = addChild(new Bitmap()) as Bitmap;
			_grid = addChild(new Shape()) as Shape;
			_highlight = addChild(new Shape()) as Shape;
			
			_facesHistory = new Dictionary();
			
			filters = [new DropShadowFilter(0,0,0,.25,10,10,1,3)];
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions, false, 1);//Higher priority to be sure it's called before panel's listener
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			if(stage == null) return;
			
			var i:int, len:int;
			len = 16;
			_grid.graphics.clear();
			for(i = 0; i < len + 1; ++i) {
				_grid.graphics.beginFill(0xffffff, 1);
				_grid.graphics.drawRect(i * _CELL_SIZE, 0, 1, len * _CELL_SIZE);
				_grid.graphics.endFill();
				
				_grid.graphics.beginFill(0xffffff, 1);
				_grid.graphics.drawRect(0, i * _CELL_SIZE, len * _CELL_SIZE, 1);
				_grid.graphics.endFill();
			}
			
			_bmp.scaleX = _bmp.scaleY = _CELL_SIZE;
			
			x = 10;
			y = Math.round((stage.stageHeight - height) * .5);
		}
		
		/**
		 * Adds the current image to the history.
		 */
		private function addImageToHistory():void {
			if(_historyPointer < _history.length - 1) {
				_history.splice(_historyPointer + 1, _history.length - _historyPointer - 1);
			}
			_historyPointer = _history.push(_bmp.bitmapData.clone()) - 1;
		}
		
		
		
		
		//__________________________________________________________ KEYBOARD EVENTS
		
		/**
		 * Called when a key is released.
		 */
		private function keyUpHandler(event:KeyboardEvent):void {
			if(!event.ctrlKey) return;
			var oldPointer:int = _historyPointer;
			if(event.keyCode == Keyboard.Z) {
				_historyPointer --;
			}else if(event.keyCode == Keyboard.Y) {
				_historyPointer ++;
			}
			if(_historyPointer > _history.length - 1) _historyPointer = _history.length - 1;
			if(_historyPointer < 0) _historyPointer = 0;
			
			if(_historyPointer != oldPointer) {
				var bmd:BitmapData = _history[_historyPointer];
				_bmp.bitmapData.copyPixels(bmd, bmd.rect, new Point(0,0));
			}
		}
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when the mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_bitmapModified = false;
//			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			mouseMoveHandler(event);
		}

		/**
		 * Called when the mouse is released.
		 * Manage modification history
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			if(_bitmapModified) {
				addImageToHistory();
			}
			_pressed = false;
			_bitmapModified = false;
//			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * Called when the mouse is moved.
		 */
		private function mouseMoveHandler(event:MouseEvent):void {
			var pos:Point = new Point(Math.floor(_grid.mouseX/_CELL_SIZE), Math.floor(_grid.mouseY/_CELL_SIZE));
			//Check if we're over the grid or not
			if(pos.x < 0 || pos.y < 0 || pos.x > 15 || pos.y > 15) {
				_highlight.visible = false;
				return;
			}

			_highlight.visible = true;
			_highlight.x = pos.x * _CELL_SIZE;
			_highlight.y = pos.y * _CELL_SIZE;
			
			_highlight.graphics.clear();
			//Sets the color of the higlight depending on the luminosity of the pixel
			//under it. To be sure it will be visible over dark and bright colors.
			_highlight.graphics.beginFill(ColorFunctions.getLuminosity(_bmp.bitmapData.getPixel(pos.x, pos.y)) > ColorFunctions.LMAX*.5? 0 : 0xffffff, .35);
			_highlight.graphics.drawRect(0, 0, _CELL_SIZE, _CELL_SIZE);
			_highlight.graphics.endFill();
			
			if(!_pressed) return;
			
			var color:int = _color == uint.MAX_VALUE? 0 : _color + 0xff000000;
			
			switch(_tool){
				case ToolType.PAINT_BUCKET:
					_bmp.bitmapData.floodFill(pos.x, pos.y, color);
					_bitmapModified = true;
					break;
				case ToolType.PIPETTE:
					FrontControlerKB.getInstance().setCurrentColor(_bmp.bitmapData.getPixel(pos.x, pos.y));
					break;
				case ToolType.PENCIL:
				default:
					_bmp.bitmapData.setPixel32(pos.x, pos.y, color);
					_bitmapModified = true;
					break;
			}
		}
		
	}
}