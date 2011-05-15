package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.common.views.ExceptionView;
	import gs.TweenLite;

	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	/**
	 * Displays the disable layer when opening a kube.
	 * 
	 * @author Francois
	 */
	public class DisableLayerView extends AbstractView {
		
		private var _opened:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>DisableLayerView</code>.
		 */
		public function DisableLayerView() {
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
			var model:ModelKR = event.model as ModelKR;
			_opened = model.openedCube != null;
			if(_opened) render();
			TweenLite.to(this, .25, {autoAlpha:_opened? 1 : 0, onUpdate:render});
			
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, render);
			render();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function render(event:Event = null):void {
			if(!_opened) return;
			
			var kubeView:SingleKubeView = ViewLocator.getInstance().locateViewByType(SingleKubeView) as SingleKubeView;
			var exceptionView:ExceptionView = ViewLocator.getInstance().locateViewByType(ExceptionView) as ExceptionView;
			var oldEVState:Boolean = exceptionView.visible;
			kubeView.visible = false;
			exceptionView.visible = false;
			visible = false;
			var bmd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			bmd.draw(stage);
			bmd.applyFilter(bmd, bmd.rect, new Point(0,0), new BlurFilter(8,8,3));
			graphics.clear();
			graphics.beginBitmapFill(bmd);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
//			bmd.dispose();
			visible = true;
			kubeView.visible = true;
			exceptionView.visible = oldEVState;
		}
		
	}
}