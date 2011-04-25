package com.muxxu.kube.common.components.form.input {
	import com.muxxu.kube.kubebuilder.graphics.InputSkin;
	import com.nurun.components.form.Input;
	import com.nurun.components.vo.Margin;
	
	/**
	 * 
	 * @author Francois
	 */
	public class InputKube extends Input {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KBInput</code>.
		 */
		public function InputKube(defaultLabel:String = "") {
			super("input", new InputSkin(), defaultLabel, "inputDefault", new Margin(4, 2, 4, 2));
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		public function set enabled(value:Boolean):void {
			mouseEnabled = value;
			mouseChildren = value;
			textfield.tabEnabled = value;
			alpha = value? 1 : .5;
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}