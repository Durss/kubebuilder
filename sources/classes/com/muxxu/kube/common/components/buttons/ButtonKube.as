package com.muxxu.kube.common.components.buttons {
	import com.muxxu.kube.kubebuilder.graphics.ButtonWarnSkin;
	import flash.display.MovieClip;
	import com.nurun.components.button.TextAlign;
	import com.nurun.components.button.IconAlign;
	import com.nurun.components.vo.Margin;
	import com.nurun.components.button.visitors.CssVisitor;
	import com.nurun.components.button.visitors.applyDefaultFrameVisitorNoTween;
	import com.muxxu.kube.kubebuilder.graphics.ButtonSkin;
	import com.nurun.components.button.BaseButton;

	import flash.display.DisplayObject;
	
	/**
	 * Creates a pre-skinned button.
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
		public function ButtonKube(label:String, big:Boolean = false, icon:DisplayObject = null, warnType:Boolean = false) {
			super(label, big? "buttonBig" : "button", warnType? new ButtonWarnSkin() : new ButtonSkin(), icon);
			contentMargin = big? new Margin(10, 5, 10, 5) : new Margin(2, 1, 2, 1);
			textBoundsMode = false;
			iconAlign = IconAlign.LEFT;
			textAlign = icon == null? TextAlign.CENTER : TextAlign.LEFT;
			iconSpacing = big? 10 : 5;
			applyDefaultFrameVisitorNoTween(this, background);
			if(icon != null && icon is MovieClip) applyDefaultFrameVisitorNoTween(this, icon);
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