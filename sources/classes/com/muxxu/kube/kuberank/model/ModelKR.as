package com.muxxu.kube.kuberank.model {
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.muxxu.kube.kuberank.cmd.LoadCubesCmd;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.mvc.model.IModel;

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
		private var _lock:Boolean;
		
		
		
		
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
			//Do not clear the previous command, that the item are still loaded
			//and there won't be "holes" in the slide.
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
			lock();
			_sortByDate = byDate;
			_top3Mode = false;//!_sortByDate;
			_startIndex = 0;
			_length = _top3Mode? 3 : _ITEMS_PER_PAGE * 2;
			_data.clear();
			loadCubes();
		}
		
		/**
		 * Sets the current display index.
		 * The index represents the kubes at the right of the screen.
		 */
		public function setCurrentDisplayIndex(index:int):void {
			if(!_top3Mode && index + 9 > _startIndex + _length && index < _totalResults) {
				_startIndex += _length;
				loadCubes();
			}
		}
		
		/**
		 * Shows the full list of kubes
		 */
		public function showFullList():void {
			lock();
			_startIndex = 0;
			_length = _ITEMS_PER_PAGE * 2;//load two pages
			_top3Mode = false;
			loadCubes();
		}
		
		/**
		 * Shows the top 3
		 */
		public function showTop3():void {
			lock();
			_top3Mode = true;
			_startIndex = 0;
			_length = 3;
			loadCubes();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			lock();
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
			_totalResults = parseInt(XML(event.data).child("pagination").@total);
			var startIndex:Number = parseInt(XML(event.data).child("pagination").@startIndex);
			_data.populate(XML(event.data).child("kubes")[0], startIndex);
			update();
			unlock();
		}
		
		/**
		 * Fires an update to the views.
		 */
		private function update():void {
			dispatchEvent(new KubeModelEvent(KubeModelEvent.UPDATE, this));
		}
		
		/**
		 * Tells the view that the model is locked
		 */
		private function lock():void {
			_lock = true;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.LOCK, this));
		}
		
		/**
		 * Tells the view that the model is unlocked
		 */
		private function unlock():void {
			_lock = true;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.UNLOCK, this));
		}
		
	}
}