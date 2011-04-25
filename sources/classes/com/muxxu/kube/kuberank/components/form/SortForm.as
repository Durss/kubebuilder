package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.form.events.FormComponentGroupEvent;
	import com.nurun.utils.pos.PosUtils;
	import com.nurun.structure.environnement.label.Label;
	import com.muxxu.kube.common.components.form.KubeCheckBox;
	import com.nurun.components.form.FormComponentGroup;
	import com.nurun.components.text.CssTextField;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 */
	public class SortForm extends Sprite {
		private var _title:CssTextField;
		private var _group:FormComponentGroup;
		private var _dateCB:KubeCheckBox;
		private var _votesCB:KubeCheckBox;
		
		
		
		
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


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_group = new FormComponentGroup();
			_title = addChild(new CssTextField("menuTitle")) as CssTextField;
			_dateCB = addChild(new KubeCheckBox(Label.getLabel("sortByDate"))) as KubeCheckBox;
			_votesCB = addChild(new KubeCheckBox(Label.getLabel("sortByVotes"))) as KubeCheckBox;
			
			_group.add(_dateCB);
			_group.add(_votesCB);
			
			_dateCB.selected = true;
			
			_group.addEventListener(FormComponentGroupEvent.CHANGE, changeSelectionHandler);
			
			computePositions();
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			PosUtils.vPlaceNext(5, _title, _votesCB, _dateCB);
		}
		
		/**
		 * Called when a new checkbox is selected
		 */
		private function changeSelectionHandler(event:FormComponentGroupEvent):void {
			FrontControlerKR.getInstance().sort(_dateCB.selected);
		}
		
	}
}