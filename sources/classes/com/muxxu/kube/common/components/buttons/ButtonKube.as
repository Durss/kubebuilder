package com.muxxu.kube.common.components.buttons {
	import com.nurun.components.button.TextAlign;
	import com.nurun.components.button.IconAlign;
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
	public class ButtonKube extends BaseButton {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KBButton</code>.
		 */
		public function ButtonKube(label:String, big:Boolean = false, icon:DisplayObject = null) {
			super(label, big? "buttonBig" : "button", new ButtonSkin(), icon);
			contentMargin = big? new Margin(5, 5, 5, 5) : new Margin(0, 2, 0, 2);
			textBoundsMode = false;
			iconAlign = IconAlign.LEFT;
			textAlign = icon == null? TextAlign.CENTER : TextAlign.LEFT;
			iconSpacing = big? 10 : 5;
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