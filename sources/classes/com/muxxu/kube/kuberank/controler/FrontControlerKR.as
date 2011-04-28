package com.muxxu.kube.kuberank.controler {
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.structure.mvc.model.IModel;

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
		public function initialize(model:IModel):void {
			_model = model as ModelKR;
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
		
		/**
		 * Opens a cube
		 */
		public function openKube(data:CubeData):void {
			_model.openKube(data);
		}
		
		/**
		 * Closes a cube
		 */
		public function closeKube():void {
			_model.closeKube();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}