package com.muxxu.kube.kuberank.views {
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import com.muxxu.kube.kubebuilder.graphics.GradientMenuSplitter;
	import com.muxxu.kube.kubebuilder.graphics.VerticalSplitterGraphic;
	import com.muxxu.kube.kuberank.components.form.PaginationForm;
	import com.muxxu.kube.kuberank.components.form.SortForm;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;
	
	/**
	 * 
	 * @author Francois
	 */
	public class MenuView extends AbstractView {
		
		private var _splitterV1:VerticalSplitterGraphic;
		private var _splitterV2:VerticalSplitterGraphic;
		private var _sortForm:SortForm;
		private var _paginationForm:PaginationForm;
		private var _shadow:GradientMenuSplitter;
		
		
		
		
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
			_paginationForm.update(model.startIndex, model.totalResults, model.data.length);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_shadow = addChild(new GradientMenuSplitter()) as GradientMenuSplitter;
			_splitterV1 = addChild(new VerticalSplitterGraphic()) as VerticalSplitterGraphic;
			_splitterV2 = addChild(new VerticalSplitterGraphic()) as VerticalSplitterGraphic;
			_sortForm = addChild(new SortForm()) as SortForm;
			_paginationForm = addChild(new PaginationForm()) as PaginationForm;
			
			_splitterV1.filters = _splitterV2.filters = 
			[ new BevelFilter(5,135,0xffffff,1,0,1,5,5,.2,3),
			new DropShadowFilter(0, 0, 0, .4, 5, 5, 1, 3) ];
			
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
			_splitterV1.x = 165;
			_splitterV1.y = 4;
			_splitterV2.y = 4;
			_splitterV1.width = _splitterV2.width = 4;
			_splitterV1.height = _splitterV2.height = 70;
			
			_sortForm.x = 4;
			_sortForm.y = 8;
			
			_paginationForm.x = stage.stageWidth - _paginationForm.width - 1;
			_paginationForm.y = 6;
			
			_splitterV2.x = _paginationForm.x - 8;
		}
		
	}
}