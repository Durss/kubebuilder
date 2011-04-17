package com.muxxu.kube.kubebuilder.components.buttons {
	import com.nurun.components.vo.Margin;
	import com.nurun.components.button.visitors.CssVisitor;
	import com.nurun.components.button.visitors.applyDefaultFrameVisitorNoTween;
	import com.muxxu.kube.kubebuilder.graphics.ButtonSkin;
	import com.nurun.components.button.BaseButton;

	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @author Francois
	 */
	public class KBButton extends BaseButton {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KBButton</code>.
		 */
		public function KBButton(label:String, icon:DisplayObject = null) {
			super(label, "button", new ButtonSkin(), icon);
			contentMargin = new Margin(0, 2, 0, 2);
			textBoundsMode = false;
			applyDefaultFrameVisitorNoTween(this, background);
			if(icon != null) applyDefaultFrameVisitorNoTween(this, icon);
			accept(new CssVisitor());
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
		
	}
}