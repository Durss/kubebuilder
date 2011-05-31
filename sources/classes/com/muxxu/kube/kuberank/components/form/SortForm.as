package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.common.components.form.KubeRadioButton;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.form.FormComponentGroup;
	import com.nurun.components.form.events.FormComponentGroupEvent;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 */
	public class SortForm extends Sprite {
		
		private var _title:CssTextField;
		private var _group:FormComponentGroup;
		private var _dateRB:KubeRadioButton;
		private var _votesRB:KubeRadioButton;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SortForm</code>.
		 */
		public function SortForm() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Updates the buttons states.
		 */
		public function update(sortByDate:Boolean):void {
			_group.removeEventListener(FormComponentGroupEvent.CHANGE, changeSelectionHandler);
			_votesRB.selected = !sortByDate;
			_dateRB.selected = sortByDate;
			_group.addEventListener(FormComponentGroupEvent.CHANGE, changeSelectionHandler);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_group = new FormComponentGroup();
			_title = addChild(new CssTextField("menuTitle")) as CssTextField;
			_dateRB = addChild(new KubeRadioButton(Label.getLabel("sortByDate"), _group)) as KubeRadioButton;
			_votesRB = addChild(new KubeRadioButton(Label.getLabel("sortByVotes"), _group)) as KubeRadioButton;
			
			_title.text = Label.getLabel("sortTitle");
			
			_votesRB.selected = true;
			_dateRB.x = _votesRB.x = 15;
			
			_group.addEventListener(FormComponentGroupEvent.CHANGE, changeSelectionHandler);
			
			computePositions();
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			PosUtils.vPlaceNext(5, _title, _votesRB, _dateRB);
			_votesRB.y -=4;
			_dateRB.y -=4;
		}
		
		/**
		 * Called when a new checkbox is selected
		 */
		private function changeSelectionHandler(event:FormComponentGroupEvent):void {
			FrontControlerKR.getInstance().sort(_dateRB.selected);
		}
		
	}
}