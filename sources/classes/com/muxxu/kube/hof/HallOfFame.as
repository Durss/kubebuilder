package com.muxxu.kube.hof {
	import flash.display.MovieClip;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	 
	[SWF(width="800", height="600", backgroundColor="0xFFFFFF", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.hof.HallOfFameLoader")]
	public class HallOfFame extends MovieClip {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.
		 */
		public function HallOfFame() {
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