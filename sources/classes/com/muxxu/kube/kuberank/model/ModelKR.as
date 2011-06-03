package com.muxxu.kube.kuberank.model {
	import com.nurun.structure.environnement.label.Label;
	import com.muxxu.kube.common.error.KubeExceptionLevel;
	import com.muxxu.kube.common.error.KubeException;
	import com.muxxu.kube.kuberank.cmd.ReportCmd;
	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.muxxu.kube.kuberank.cmd.LoadCubesCmd;
	import com.muxxu.kube.kuberank.cmd.VoteCmd;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ModelKR extends EventDispatcher implements IModel {
		
		private const _ITEMS_PER_PAGE:int = 18;
		private var _data:CubeDataCollection;
		private var _sortByDate:Boolean;
		private var _totalResults:Number;
		private var _startIndex:int;
		private var _length:int;
		private var _userName:String;
		private var _top3Mode:Boolean;
		private var _openedCube:CubeData;
		private var _lock:Boolean;
		private var _votesDone:Number;
		private var _votesTotal:Number;
		private var _lastSearchName:String;
		
		
		
		
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

		public function get votesDone():Number { return _votesDone; }

		public function get votesTotal():Number { return _votesTotal; }

		public function get userName():String { return _userName; }



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
			//Do not clear the previous command, that, the items are still loaded
			//and there won't be "holes" in the slide.
			var cmd:LoadCubesCmd = new LoadCubesCmd(Config.getPath("getKubes"), _startIndex, _length, _userName, _sortByDate, _top3Mode? Config.getNumVariable("newItemsToShow") : 0);
			cmd.addEventListener(CommandEvent.COMPLETE, loadCubesCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Votes for a specific kube
		 */
		public function vote(cube:CubeData):void {
			lock();
			var cmd:VoteCmd = new VoteCmd(Config.getPath("postVote"), cube);
			cmd.addEventListener(CommandEvent.COMPLETE, voteCubeCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Reports a specific kube as bad.
		 */
		public function report(cube:CubeData):void {
			lock();
			var cmd:ReportCmd = new ReportCmd(Config.getPath("postReport"), cube);
			cmd.addEventListener(CommandEvent.COMPLETE, reportCubeCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Sorts the results.
		 * 
		 * @param byDate	defines if the results should be sorted by date. Else it's by votes
		 */
		public function sort(byDate:Boolean):void {
			lock();
			_sortByDate = byDate;
			_top3Mode = false;
			_startIndex = 0;
			_length = _ITEMS_PER_PAGE * 2;
			_userName = "";
			_lastSearchName = "";
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
		 * Shows the top 3
		 */
		public function showTop3():void {
			lock();
			_top3Mode = true;
			_startIndex = 0;
			_length = 3;
			_sortByDate = false;
			_userName = "";
			_lastSearchName = "";
			_data.clear();
			loadCubes();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			if(userName == _lastSearchName) return;
			lock();
			_lastSearchName = userName;
			_userName = userName;
			_top3Mode = false;
			_sortByDate = true;
			_startIndex = 0;
			_length = _ITEMS_PER_PAGE * 2;
			loadCubes();
		}
		
		/**
		 * Loads a specific kube
		 */
		public function loadKube(kubeId:String):void {
			//Do not clear the previous command, that, the items are still loaded
			//and there won't be "holes" in the slide.
			var cmd:LoadCubesCmd = new LoadCubesCmd(Config.getPath("getKubes"), 0, 1, null, false, 0, kubeId);
			cmd.addEventListener(CommandEvent.COMPLETE, loadSingleCubesCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Opens a cube
		 */
		public function openKube(vo:CubeData):void {
			if(vo.id == -1) {
				navigateToURL(new URLRequest(Config.getPath("editorPage")), "_self");
			}else{
				_openedCube = vo;
				update();
			}
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
			_votesDone = Config.getNumVariable("votesDone");
			_votesTotal = Config.getNumVariable("votesTotal");
			//Opens default kube if a directKube is defined (direct link to a specific kube)
			if(Config.getVariable("directKube") != null) {
				_openedCube = new CubeData(0);
				_openedCube.populate(new XML(Config.getVariable("directKube")));
			}
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
		 * Called when a single kube's information loading completes
		 */
		private function loadSingleCubesCompleteHandler(event:CommandEvent):void {
			_openedCube = new CubeData(0);
			_openedCube.populate(XML(event.data).child("kubes")[0].child("kube")[0]);
			update();
			unlock();
		}
		
		/**
		 * Called when cube's vote completes.
		 */
		private function voteCubeCompleteHandler(event:CommandEvent):void {
			VoteCmd(event.target).cubeData.voted = true;
			_votesDone = parseInt(XML(event.data).child("result").@votesDone);
			_votesTotal = parseInt(XML(event.data).child("result").@totalVotes);
			update();
			unlock();
		}
		
		/**
		 * Called when a kube report completes
		 */
		private function reportCubeCompleteHandler(event:CommandEvent):void {
			unlock();
			throw(new KubeException(Label.getLabel("reportSuccess"), KubeExceptionLevel.SUCCESS));
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
		private function lock(...args):void {
			_lock = true;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.LOCK, this));
		}
		
		/**
		 * Tells the view that the model is unlocked
		 */
		private function unlock(...args):void {
			_lock = true;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.UNLOCK, this));
		}
		
	}
}