package com.muxxu.kube.kubebuilder.controler {
	
	import com.muxxu.kube.kubebuilder.model.Model;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Singleton FrontControler
	 * 
	 * @author Francois
	 */
	public class FrontControler {
		private static var _instance:FrontControler;
		private var _model:Model;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>FrontControler</code>.
		 */
		public function FrontControler(enforcer:SingletonEnforcer) {
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
		public static function getInstance():FrontControler {
			if(_instance == null)_instance = new  FrontControler(new SingletonEnforcer());
			return _instance;	
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Initialize the controler with the model.
		 */
		public function initialize(model:Model):void {
			_model = model;
		}
		
		/**
		 * Sets the current edition's color.
		 */
		public function setCurrentColor(color:uint):void {
			_model.setCurrentColor(color);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}