package com.muxxu.kube.kuberank.model {
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.muxxu.kube.kuberank.cmd.LoadCubesCmd;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.model.events.ModelEvent;

	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ModelKR extends EventDispatcher implements IModel {
		
		private const _ITEMS_PER_PAGE:int = 18;
		private var _data:CubeDataCollection;
		private var _cmd:LoadCubesCmd;
		private var _sortByDate:Boolean;
		private var _totalResults:Number;
		private var _startIndex:int;
		private var _length:int;
		private var _userName:String;
		private var _top3Mode:Boolean;
		private var _openedCube:CubeData;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ModelKR</code>.
		 */
		public function ModelKR() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get data():CubeDataCollection { return _data; }

		public function get sortByDate():Boolean { return _sortByDate; }

		public function get totalResults():Number { return _totalResults; }

		public function get startIndex():int { return _startIndex; }

		public function get top3Mode():Boolean { return _top3Mode; }

		public function get openedCube():CubeData { return _openedCube; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Starts thee application
		 */
		public function start():void {
			_startIndex = 0;
			_length = 3;
			_top3Mode = true;
			loadCubes();
		}
		
		/**
		 * Loads the cubes list
		 */
		public function loadCubes():void {
			if(_cmd != null) {
				_cmd.dispose();
				_cmd.removeEventListener(CommandEvent.COMPLETE, loadCubesCompleteHandler);
			}
			
			_cmd = new LoadCubesCmd(Config.getPath("getKubes"), _startIndex, _length, _userName, _sortByDate);
			_cmd.addEventListener(CommandEvent.COMPLETE, loadCubesCompleteHandler);
			_cmd.execute();
		}
		
		/**
		 * Sorts the results.
		 * 
		 * @param byDate	defines if the results should be sort by date. Else it's by votes
		 */
		public function sort(byDate:Boolean):void {
//			var exMode:Boolean = _top3Mode;
			_sortByDate = byDate;
			_top3Mode = !_sortByDate;
			_startIndex = 0;
			_length = _top3Mode? 3 : _ITEMS_PER_PAGE;
//			if(_data.length == 0 || exMode != _top3Mode) {
				loadCubes();
//			}else{
//				_data.sort(byDate);
//				update();
//			}
		}
		
		/**
		 * Loads the next page of results.
		 */
		public function loadNextPage():void {
			_startIndex += _top3Mode? 3 : _ITEMS_PER_PAGE;
			_length = _ITEMS_PER_PAGE;
			_top3Mode = false;
			loadCubes();
		}
		
		/**
		 * Loads the previous page of results.
		 */
		public function loadPrevPage():void {
			_startIndex -= _ITEMS_PER_PAGE;
			if(_startIndex < 0) _startIndex = 0;
			_top3Mode = !_sortByDate && _startIndex == 0;
			_length = _top3Mode? 3 : _ITEMS_PER_PAGE;
			loadCubes();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			_userName = userName;
			_top3Mode = false;
			loadCubes();
		}
		
		/**
		 * Opens a cube
		 */
		public function openKube(data:CubeData):void {
			_openedCube = data;
			update();
		}
		
		/**
		 * Closes a cube
		 */
		public function closeKube():void {
			_openedCube = null;
			update();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_data = new CubeDataCollection();
			_userName = "";
		}
		
		/**
		 * Called when cubes loading completes.
		 */
		private function loadCubesCompleteHandler(event:CommandEvent):void {
			_totalResults = XML(event.data).child("pagination").@total;
			_data.clear();
			_data.populate(XML(event.data).child("kubes")[0]);
			update();
		}
		
		/**
		 * Fires an update to the views.
		 */
		private function update():void {
			dispatchEvent(new ModelEvent(ModelEvent.UPDATE, this));
		}
		
	}
}