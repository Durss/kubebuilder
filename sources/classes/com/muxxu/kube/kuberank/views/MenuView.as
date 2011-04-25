package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.common.vo.SplitterType;
	import com.muxxu.kube.common.components.Splitter;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	
	/**
	 * 
	 * @author Francois
	 */
	public class MenuView extends AbstractView {
		private var _splitterH:Splitter;
		private var _splitterV1:Splitter;
		private var _splitterV2:Splitter;
		
		
		
		
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
			
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			
		}
		
	}
}