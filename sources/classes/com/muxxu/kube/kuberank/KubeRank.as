package com.muxxu.kube.kuberank {
	import flash.display.MovieClip;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 */
	 
	[SWF(width="800", height="500", backgroundColor="#4CA5CD", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.kuberank.KubeRankLoader")]
	public class KubeRank extends MovieClip {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.<br>
		 */
		public function KubeRank() {
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
		 * Initialize the class.<br>s
		 */
		private function initialize():void {
			
			computePositions();
		}
		
		/**
		 * Resize and replace the elements.<br>
		 */
		private function computePositions():void {
			
		}
		
	}
}