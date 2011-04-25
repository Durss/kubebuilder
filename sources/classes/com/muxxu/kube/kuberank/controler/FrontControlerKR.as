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
		
		/**
		 * Sorts the results.
		 * 
		 * @param byDate	defines if the results should be sort by date. Else it's by votes
		 */
		public function sort(byDate:Boolean):void {
			_model.sort(byDate);
		}
		
		/**
		 * Loads the next page of results.
		 */
		public function loadNextPage():void {
			_model.loadNextPage();
		}
		
		/**
		 * Loads the previous page of results.
		 */
		public function loadPrevPage():void {
			_model.loadPrevPage();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			_model.searchKubesOfUser(userName);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}