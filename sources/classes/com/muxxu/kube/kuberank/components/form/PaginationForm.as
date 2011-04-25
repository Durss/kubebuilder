package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import flash.events.MouseEvent;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.nurun.components.vo.Margin;
	import com.nurun.structure.environnement.label.Label;

	import flash.display.Sprite;
	
	/**
	 * Displays the pagination form (actually it's just prev and button for now)
	 * 
	 * @author Francois
	 */
	public class PaginationForm extends Sprite {
		private var _nextPageBt:ButtonKube;
		private var _prevPageBt:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PaginationForm</code>.
		 */
		public function PaginationForm() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		override public function get width():Number { return _nextPageBt.width; }



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
			_nextPageBt = addChild(new ButtonKube(Label.getLabel("nextPage"), true)) as ButtonKube;
			_prevPageBt = addChild(new ButtonKube(Label.getLabel("prevPage"), true)) as ButtonKube;
			
			_nextPageBt.width = _prevPageBt.width = Math.max(_nextPageBt.width, _prevPageBt.width) + 5;
			_nextPageBt.contentMargin = _prevPageBt.contentMargin = new Margin(0, 2, 0, 1);
			
			_nextPageBt.height = Math.round(_nextPageBt.height);
			_prevPageBt.height = Math.round(_prevPageBt.height);
			_nextPageBt.y = _prevPageBt.height;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _nextPageBt) {
				FrontControlerKR.getInstance().loadNextPage();
			}else{
				FrontControlerKR.getInstance().loadPrevPage();
			}
		}
		
	}
}