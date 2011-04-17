package com.muxxu.kube.kubebuilder.components.form {
	import flash.events.Event;
	import gs.TweenLite;

	import com.muxxu.kube.kubebuilder.components.buttons.KBButton;
	import com.nurun.components.form.events.FormComponentEvent;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;
	import com.nurun.utils.string.StringUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[Event(name="onSubmitForm", type="com.nurun.components.form.events.FormComponentEvent")]
	
	/**
	 * Displays the submit form.
	 * Provides the user a way to upload its kube.
	 * 
	 * @author Francois
	 */
	public class SubmitForm extends Sprite {
		
		private var _nameInput:KBInput;
		private var _submitBt:KBButton;
		private var _title:CssTextField;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SubmitForm</code>.
		 */
		public function SubmitForm() {
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
			_nameInput = addChild(new KBInput()) as KBInput;
			_submitBt = addChild(new KBButton(Label.getLabel("formSubmit"))) as KBButton;
			_title = addChild(new CssTextField("formTitle")) as CssTextField;
			
			_title.text = Label.getLabel("formTitle");
			
			computePositions();
			
			_submitBt.addEventListener(MouseEvent.CLICK, submitHandler);
			_nameInput.addEventListener(FormComponentEvent.SUBMIT, submitHandler);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_nameInput.width = 
			_title.width =
			_submitBt.width = 200;
			
			_submitBt.validate();
			_nameInput.validate();
			
			PosUtils.vPlaceNext(5, _title, _nameInput, _submitBt);
		}
		
		/**
		 * Called when the user clicks the submit button.
		 */
		private function submitHandler(event:Event):void {
			if(StringUtils.trim(_nameInput.text).length == 0) {
				TweenLite.from(_nameInput, .5, {colorMatrixFilter:{colorize:0xff0000, remove:true}});
				stage.focus = _nameInput;
			}else{
				dispatchEvent(new FormComponentEvent(FormComponentEvent.SUBMIT));
			}
		}
		
	}
}