package com.muxxu.kube.kubebuilder.views {
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.muxxu.kube.kubebuilder.components.buttons.PanelButton;
	import com.muxxu.kube.kubebuilder.components.panel.PanelPatronContent;
	import com.muxxu.kube.kubebuilder.components.panel.PanelToolsContent;
	import com.muxxu.kube.kubebuilder.model.Model;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author Francois
	 */
	public class PanelView extends AbstractView {
		
		private static const _CONTENT_WIDTH:int = 200;
		private static const _CONTENT_HEIGHT:int = 314;
		
		private var _toolsBt:PanelButton;
		private var _patronBt:PanelButton;
		private var _patronContent:PanelPatronContent;
		private var _toolsContent:PanelToolsContent;
		private var _buttonsCtn:Sprite;
		private var _previousButton:PanelButton;
		private var _mainHolder:Sprite;
		private var _initialized:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PanelView</code>.
		 */
		public function PanelView() {
			initialize();
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
			model;//Prevents from unused warnings on FDT
			_patronContent.populate(model.kubeData);
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_mainHolder = addChild(new Sprite()) as Sprite;
			_buttonsCtn = _mainHolder.addChild(new Sprite()) as Sprite;
			
			_toolsBt = _buttonsCtn.addChild(new PanelButton(Label.getLabel("tools"))) as PanelButton;
			_patronBt = _buttonsCtn.addChild(new PanelButton(Label.getLabel("patron"))) as PanelButton;
			_patronContent = _mainHolder.addChild(new PanelPatronContent()) as PanelPatronContent;
			_toolsContent = _mainHolder.addChild(new PanelToolsContent()) as PanelToolsContent;
			
			_toolsBt.width = _patronBt.width = _CONTENT_HEIGHT * .5 + 1;
			_toolsBt.rotation = _patronBt.rotation = 90;
			_patronBt.y = _toolsBt.width - 1;
			_toolsBt.x = _patronBt.x = _toolsBt.height;
			_toolsBt.validate();
			_patronBt.validate();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			var grid:EditorView = ViewLocator.getInstance().locateViewByType(EditorView) as EditorView;
			if(grid == null) return;
			
			_mainHolder.graphics.clear();
			_mainHolder.graphics.lineStyle(0,0xffffff,1);
			_mainHolder.graphics.beginFill(0x428DAC, 1);
			_mainHolder.graphics.drawRect(0, 0, _CONTENT_WIDTH, _CONTENT_HEIGHT);
			_mainHolder.graphics.endFill();
			
			_buttonsCtn.x = _CONTENT_WIDTH;
			_toolsContent.x = 12;
			_patronContent.x = 3;
			_toolsContent.y = _patronContent.y = 10;
			
			x = Math.round(grid.x + grid.width - 1);
			y = grid.y + 2;
			if(!_initialized) {
				_initialized = true;
				//Close the panel at its first rendering.
				_mainHolder.x = -_mainHolder.width + _toolsBt.height;
			}
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(!(event.target is PanelButton)) return;
			
			if(event.target == _previousButton) {
				_previousButton = null;
				TweenLite.to(_mainHolder, .25, {x:-_mainHolder.width + _toolsBt.height, ease:Sine.easeInOut});
			}else{
				TweenLite.to(_mainHolder, .25, {x:0, ease:Sine.easeInOut});
				_toolsContent.visible = event.target == _toolsBt;
				_patronContent.visible = event.target == _patronBt;
				_previousButton = event.target as PanelButton;
			}
			
		}
		
	}
}