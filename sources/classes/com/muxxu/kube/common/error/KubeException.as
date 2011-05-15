package com.muxxu.kube.common.error {
	
	/**
	 * 
	 * @author Francois
	 */
	public class KubeException extends Error {
		
		private var _level:int;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeException</code>.
		 */
		public function KubeException(message:String, level:int) {
			_level = level;
			super(message, 0);
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the exception level.
		 */
		public function get level():int { return _level; }



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}