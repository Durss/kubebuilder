package com.muxxu.kube.kubebuilder.views {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import com.muxxu.kube.kubebuilder.model.Model;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	
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
			var model:Model = event.model as Model;
			_bmp.bitmapData = model.currentFace;
			_color = model.color;
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
			
			x = 30;
			y = Math.round((stage.stageHeight - height) * .5);
		}
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when the mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			mouseMoveHandler(event);
		}

		/**
		 * Called when the mouse is released.
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * Called when the mouse is moved.
		 */
		private function mouseMoveHandler(event:MouseEvent):void {
			var pos:Point = new Point(Math.floor(_grid.mouseX/_CELL_SIZE), Math.floor(_grid.mouseY/_CELL_SIZE));
			_bmp.bitmapData.setPixel(pos.x, pos.y, _color);
		}
		
	}
}