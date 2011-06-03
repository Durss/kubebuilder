package com.muxxu.kube.common.components {
	import flash.events.Event;
	import com.muxxu.kube.kubebuilder.graphics.SpinGraphic;
	
	/**
	 * 
	 * @author Francois
	 */
	public class LoaderSpinning extends SpinGraphic {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>LoaderSpinning</code>.
		 */
		public function LoaderSpinning() {
			
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */

		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		public function open():void {
			visible = true;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		public function close():void {
			visible = false;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}



		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */

		private function enterFrameHandler(event:Event):void {
			rotation -= 15;
		}
		
	}
}