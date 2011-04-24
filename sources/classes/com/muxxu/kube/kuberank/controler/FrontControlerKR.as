package com.muxxu.kube.kuberank.controler {
	
	import com.muxxu.kube.kuberank.model.ModelKR;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Singleton FrontControlerKR
	 * 
	 * @author Francois
	 */
	public class FrontControlerKR {
		
		private static var _instance:FrontControlerKR;
		private var _model:ModelKR;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>FrontControlerKR</code>.
		 */
		public function FrontControlerKR(enforcer:SingletonEnforcer) {
			if(enforcer == null) {
				throw new IllegalOperationError("A singleton can't be instanciated. Use static accessor 'getInstance()'!");
			}
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Singleton instance getter.
		 */
		public static function getInstance():FrontControlerKR {
			if(_instance == null)_instance = new  FrontControlerKR(new SingletonEnforcer());
			return _instance;	
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Initialize the class.
		 */
		public function initialize(model:ModelKR):void {
			_model = model;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}