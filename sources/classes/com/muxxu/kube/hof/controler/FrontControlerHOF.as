package com.muxxu.kube.hof.controler {
	import com.muxxu.kube.hof.model.ModelHOF;
	import com.nurun.structure.mvc.model.IModel;

	import flash.errors.IllegalOperationError;
	
	
	/**
	 * Singleton FrontControlerHOF
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	public class FrontControlerHOF {
		
		private static var _instance:FrontControlerHOF;
		private var _model:ModelHOF;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>FrontControlerHOF</code>.
		 */
		public function FrontControlerHOF(enforcer:SingletonEnforcer) {
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
		public static function getInstance():FrontControlerHOF {
			if(_instance == null)_instance = new  FrontControlerHOF(new SingletonEnforcer());
			return _instance;	
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Initialize the class.
		 */
		public function initialize(model:IModel):void {
			_model = model as ModelHOF;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}