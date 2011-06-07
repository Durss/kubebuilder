package com.muxxu.kube.kuberank.controler {
	import com.muxxu.kube.kuberank.vo.ListData;
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
		 * @param byDate		defines if the results should be sort by date. Else it's by votes
		 */
		public function sort(byDate:Boolean):void {
			_model.sort(byDate);
		}
		
		/**
		 * Shows the top 3
		 */
		public function showTop3():void {
			_model.showTop3();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			_model.searchKubesOfUser(userName);
		}
		
		/**
		 * Loads a specific kube
		 */
		public function loadKube(kubeId:String):void {
			_model.loadKube(kubeId);
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
		
		/**
		 * Sets the current display index.
		 * The index represents the kubes at the right of the screen.
		 */
		public function setCurrentDisplayIndex(index:int):void {
			_model.setCurrentDisplayIndex(index);
		}
		
		/**
		 * Votes for a specific kube
		 */
		public function vote(cube:CubeData):void {
			_model.vote(cube);
		}
		
		/**
		 * Reports a specific kube as bad.
		 */
		public function report(cube:CubeData):void {
			_model.report(cube);
		}

		/**
		 * Deletes a kube
		 */
		public function deleteKube(data:CubeData):void {
			_model.deleteKube(data);
		}

		/**
		 * Shows the user's profile
		 */
		public function showProfile():void {
			_model.showProfile();
		}

		/**
		 * Creates a list
		 */
		public function createList(name:String):void {
			_model.createList(name);
		}
		
		/**
		 * Deletes a list
		 */
		public function deleteList(id:int):void {
			_model.deleteList(id);
		}
		
		/**
		 * Opens a list
		 */
		public function openList(id:int):void {
			_model.openList(id);
		}
		
		/**
		 * Updates a list
		 */
		public function updateList(list:ListData, addAction:Boolean, kube:CubeData):void {
			_model.updateList(list, addAction, kube);
		}
		
		/**
		 * Renames a list
		 */
		public function renameList(data:ListData, text:String):void {
			_model.renameList(data, text);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}