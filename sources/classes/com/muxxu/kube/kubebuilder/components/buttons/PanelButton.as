package com.muxxu.kube.kubebuilder.components.buttons {
	import com.nurun.components.vo.Margin;
	import com.muxxu.kube.kubebuilder.graphics.PanelButtonGraphic;
	import com.nurun.components.button.BaseButton;
	import com.nurun.components.button.visitors.CssVisitor;
	import com.nurun.components.button.visitors.applyDefaultFrameVisitorNoTween;

	import flash.filters.DropShadowFilter;
	
	/**
	 * 
	 * @author Francois
	 */
	public class PanelButton extends BaseButton {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PanelButton</code>.
		 */
		public function PanelButton(label:String) {
			super(label, "panelButton", new PanelButtonGraphic());
			applyDefaultFrameVisitorNoTween(this, background);
			
			contentMargin = new Margin(0, 3, 0, 3);
			textBoundsMode = false;
			
			accept(new CssVisitor());
			textfield.filters = [new DropShadowFilter(2,45,0,.25,1,1,1,3)];
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