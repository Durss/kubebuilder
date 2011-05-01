package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.vo.Margin;
	import com.nurun.structure.environnement.label.Label;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Displays the pagination form (actually it's just prev and button for now)
	 * 
	 * @author Francois
	 */
	public class PaginationForm extends Sprite {
		
		private var _showAllBt:ButtonKube;
		private var _showTopBt:ButtonKube;
		
		
		
		
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
		override public function get width():Number { return _showAllBt.width; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Updates the buttons states.
		 */
		public function update(topMode:Boolean):void {
			_showTopBt.enabled = !topMode;
			_showAllBt.enabled = topMode;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_showAllBt = addChild(new ButtonKube(Label.getLabel("showAll"), true)) as ButtonKube;
			_showTopBt = addChild(new ButtonKube(Label.getLabel("showTop"), true)) as ButtonKube;
			
			_showAllBt.width = _showTopBt.width = Math.max(_showAllBt.width, _showTopBt.width) + 5;
			_showAllBt.contentMargin = _showTopBt.contentMargin = new Margin(0, 2, 0, 1);
			
			_showAllBt.height = Math.round(_showAllBt.height);
			_showTopBt.height = Math.round(_showTopBt.height);
			_showAllBt.y = _showTopBt.height;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _showAllBt) {
				FrontControlerKR.getInstance().showFullList();
			}else if(event.target == _showTopBt){
				FrontControlerKR.getInstance().showTop3();
			}
		}
		
	}
}