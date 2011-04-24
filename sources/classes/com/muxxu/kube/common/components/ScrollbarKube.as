package com.muxxu.kube.common.components {
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
	public class ScrollbarKube extends Scrollbar {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KBScrollbar</code>.
		 */
		public function ScrollbarKube() {
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