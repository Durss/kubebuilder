package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.kubebuilder.graphics.GradientMenuSplitter;
	import com.muxxu.kube.kuberank.components.form.DisplayTypeForm;
	import com.muxxu.kube.kuberank.components.form.SearchForm;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	
	/**
	 * 
	 * @author Francois
	 */
	public class MenuView extends AbstractView {
		
		private var _shadow:GradientMenuSplitter;
		private var _searchForm:SearchForm;
		private var _displayTypeForm:DisplayTypeForm;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>MenuView</code>.
		 */
		public function MenuView() {
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
			_displayTypeForm.update(model.top3Mode, model.sortByDate, model.userName);
			_searchForm.update(model.userName, model.openedCube);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_shadow = addChild(new GradientMenuSplitter()) as GradientMenuSplitter;
			_searchForm = addChild(new SearchForm()) as SearchForm;
			_displayTypeForm = addChild(new DisplayTypeForm()) as DisplayTypeForm;
			
//			_splitterV1.filters = _splitterV2.filters = 
//				[ new BevelFilter(5,135,0xffffff,1,0,1,5,5,.2,3),
//				new DropShadowFilter(0, 0, 0, .4, 5, 5, 1, 3) ];
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
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
			y = 420;
			_shadow.y = -7;
			_shadow.width = stage.stageWidth;
			_displayTypeForm.y = 5;
			var offset:Number = _displayTypeForm.x + _displayTypeForm.width;
			_searchForm.x = Math.round((stage.stageWidth - offset - _searchForm.width) * .5 + offset);
		}
		
	}
}