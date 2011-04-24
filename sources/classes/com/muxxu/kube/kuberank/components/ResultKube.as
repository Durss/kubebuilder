package com.muxxu.kube.kuberank.components {
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ResultKube extends Sprite {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ResultKube</code>.
		 */
		public function ResultKube() {
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
			
			computePositions();
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			
		}
		
	}
}