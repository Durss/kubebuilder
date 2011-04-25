package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.common.components.Splitter;
	import com.muxxu.kube.common.vo.SplitterType;
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
		private var _splitterH:Splitter;
		private var _splitterV1:Splitter;
		private var _splitterV2:Splitter;
		private var _sortForm:SortForm;
		private var _paginationForm:PaginationForm;
		
		
		
		
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
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_splitterH = addChild(new Splitter(SplitterType.HORIZONTAL)) as Splitter;
			_splitterV1 = addChild(new Splitter(SplitterType.VERTICAL)) as Splitter;
			_splitterV2 = addChild(new Splitter(SplitterType.VERTICAL)) as Splitter;
			_sortForm = addChild(new SortForm()) as SortForm;
			_paginationForm = addChild(new PaginationForm()) as PaginationForm;
			
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
			_splitterV1.y = 4;
			_splitterV2.y = 4;
			_splitterV1.x = 165;
			
			_splitterH.width = stage.stageWidth;
			_splitterH.height = 4;
			
			_splitterV1.width = _splitterV2.width = 4;
			_splitterV1.height = _splitterV2.height = 80;
			
			_sortForm.x = 4;
			_sortForm.y = 8;
			
			_paginationForm.x = stage.stageWidth - _paginationForm.width - 1;
			_paginationForm.y = 6;
			
			_splitterV2.x = _paginationForm.x - 8;
		}
		
	}
}