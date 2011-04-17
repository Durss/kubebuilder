package com.muxxu.kube.kubebuilder.components {
	import com.muxxu.kube.kubebuilder.graphics.ScrollbarDownBtSkin;
	import com.muxxu.kube.kubebuilder.graphics.ScrollbarScrollerBtSkin;
	import com.muxxu.kube.kubebuilder.graphics.ScrollbarTrackBtSkin;
	import com.muxxu.kube.kubebuilder.graphics.ScrollbarUpBtSkin;
	import com.nurun.components.scroll.scroller.scrollbar.Scrollbar;
	import com.nurun.components.scroll.scroller.scrollbar.ScrollbarClassicSkin;
	
	/**
	 * 
	 * @author Francois
	 */
	public class KBScrollbar extends Scrollbar {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KBScrollbar</code>.
		 */
		public function KBScrollbar() {
			super(new ScrollbarClassicSkin(new ScrollbarUpBtSkin(), new ScrollbarDownBtSkin(), new ScrollbarScrollerBtSkin(), null, new ScrollbarTrackBtSkin()));
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