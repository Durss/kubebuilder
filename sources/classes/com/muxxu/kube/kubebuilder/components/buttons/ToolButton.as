package com.muxxu.kube.kubebuilder.components.buttons {
	import com.nurun.components.button.GraphicButton;
	import com.nurun.components.button.visitors.applyDefaultFrameVisitorNoTween;
	import com.nurun.components.form.GroupableFormComponent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * Creates a tool button (pipette, pencil, paint bucket)
	 * 
	 * @author Francois
	 */
	public class ToolButton extends GraphicButton implements GroupableFormComponent {
		
		private var _selected:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ToolButton</code>.
		 */
		public function ToolButton(icon:DisplayObject) {
			super(null, icon);
			applyDefaultFrameVisitorNoTween(this, icon);
			updateState();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean {
			return _selected;
		}

		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
			updateState();
			dispatchEvent(new Event(Event.CHANGE));
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function unSelect():void {
			_selected = false;
			updateState();
		}

		/**
		 * @inheritDoc
		 */
		public function select():void {
			_selected = true;
			updateState();
		}



		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Updates the rendering state.
		 */
		private function updateState():void {
			var matrix:Array = [.33, .33, .33, 0, 0,   /* Red */
								 .33,.33,.33,0,0,   /* Green */
								 .33,.33,.33,0,0,   /* Blue */
								 0,0,0,1,0];
			filters = _selected? [] : [new ColorMatrixFilter(matrix)];
		}
		
		/**
		 * Called when the button is clicked.
		 */
		override protected function clickHandler(event:MouseEvent):void {
			super.clickHandler(event);
			if(!enabled) return;
			selected = !selected;
		}
		
	}
}