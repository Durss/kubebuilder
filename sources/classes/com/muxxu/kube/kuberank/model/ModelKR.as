package com.muxxu.kube.kuberank.model {

	import com.nurun.core.lang.Disposable;
	import com.nurun.core.commands.Command;
	import com.muxxu.kube.kuberank.cmd.RenameListCmd;
	import com.muxxu.kube.kuberank.cmd.UpdateListCmd;
	import com.muxxu.kube.common.error.KubeException;
	import com.muxxu.kube.common.error.KubeExceptionLevel;
	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.muxxu.kube.kuberank.cmd.CreateListCmd;
	import com.muxxu.kube.kuberank.cmd.DeleteKubeCmd;
	import com.muxxu.kube.kuberank.cmd.DeleteListCmd;
	import com.muxxu.kube.kuberank.cmd.GetListsCmd;
	import com.muxxu.kube.kuberank.cmd.LoadCubesCmd;
	import com.muxxu.kube.kuberank.cmd.ReportCmd;
	import com.muxxu.kube.kuberank.cmd.VoteCmd;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.muxxu.kube.kuberank.vo.ListData;
	import com.muxxu.kube.kuberank.vo.ListDataCollection;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
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
		private var _locked:Boolean;
		private var _votesDone:Number;
		private var _votesTotal:Number;
		private var _rerootToTop3:Boolean;
		private var _profileMode:Boolean;
		private var _lists:ListDataCollection;
		private var _kubesList:int;
		private var _rerootToStart:Boolean;
		private var _forceReload:Boolean;
		private var _currentListName:String;
		private var _toConfirm:Command;
		private var _currentListAuthor:*;
		
		
		
		
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

		public function get profileMode():Boolean { return _profileMode; }

		public function get lists():ListDataCollection { return _lists; }

		public function get forceReload():Boolean { return _forceReload; }

		public function get currentListId():int { return _kubesList; }

		public function get currentListName():String { return _currentListName; }

		public function get currentListAuthor():String { return _currentListAuthor; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Starts thee application
		 */
		public function start():void {
			//Quite dirty way to complete init..
			//a SequentialCommand would have been much better but would've asked
			//for more refactoring... and i'm too lazy for that at this time :(..
			if(_rerootToStart) {
				_rerootToStart = false;
				if(Config.getVariable("userToShow") != null) {
					_rerootToTop3 = true;
					searchKubesOfUser(Config.getVariable("userToShow"));
				}else if(Config.getVariable("listToShow") != null) {
					_kubesList = -1;
					_rerootToTop3 = true;
					openList(Config.getNumVariable("listToShow"));
				}else{
					showTop3();
				}
			}else{
				_rerootToStart = true;
				getLists();
			}
		}
		
		/**
		 * Loads the cubes list
		 */
		public function loadCubes(...args):void {
			_profileMode = false;
			_currentListName = "";
			//Do not clear the previous command, that, the items are still loaded
			//and there won't be "holes" in the slide.
			var cmd:LoadCubesCmd = new LoadCubesCmd(_startIndex, _length, _userName, _sortByDate, _top3Mode? Config.getNumVariable("newItemsToShow") : 0, "", _kubesList);
			cmd.addEventListener(CommandEvent.COMPLETE, loadCubesCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, loadCubesErrorHandler);
			cmd.execute();
		}
		
		/**
		 * Votes for a specific kube
		 */
		public function vote(cube:CubeData):void {
			var cmd:VoteCmd = new VoteCmd(cube);
			cmd.addEventListener(CommandEvent.COMPLETE, voteCubeCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			askForConfirmation(cmd);
		}
		
		/**
		 * Reports a specific kube as bad.
		 */
		public function report(cube:CubeData):void {
			var cmd:ReportCmd = new ReportCmd(cube);
			cmd.addEventListener(CommandEvent.COMPLETE, reportCubeCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			askForConfirmation(cmd);
		}

		/**
		 * Deletes a kube
		 */
		public function deleteKube(data:CubeData):void {
			_forceReload = true;
			_openedCube = null;
			_top3Mode = true;
			_startIndex = 0;
			_length = 3;
			_sortByDate = false;
			_userName = "";
			_data.clear();
			var cmd:DeleteKubeCmd = new DeleteKubeCmd(data);
			cmd.addEventListener(CommandEvent.COMPLETE, deleteCubeCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			askForConfirmation(cmd);
		}
		
		/**
		 * Creates a list
		 */
		public function createList(name:String):void {
			lock();
			var cmd:CreateListCmd = new CreateListCmd(name);
			cmd.addEventListener(CommandEvent.COMPLETE, listRequestComplete);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Deletes a list
		 */
		public function deleteList(id:int):void {
			var cmd:DeleteListCmd = new DeleteListCmd(id);
			cmd.addEventListener(CommandEvent.COMPLETE, listRequestComplete);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			askForConfirmation(cmd);
		}
		
		/**
		 * Gets the user's lists
		 */
		public function getLists():void {
			lock();
			var cmd:GetListsCmd = new GetListsCmd();
			cmd.addEventListener(CommandEvent.COMPLETE, listRequestComplete);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Updates a list
		 */
		public function updateList(list:ListData, addAction:Boolean, kube:CubeData):void {
			lock();
			var cmd:UpdateListCmd = new UpdateListCmd(kube.id, list.id, addAction);
			cmd.addEventListener(CommandEvent.COMPLETE, listUpdateHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Loads a specific kube
		 */
		public function loadKube(kubeId:String):void {
			lock();
			var cmd:LoadCubesCmd = new LoadCubesCmd(0, 1, null, false, 0, kubeId);
			cmd.addEventListener(CommandEvent.COMPLETE, loadSingleCubesCompleteHandler);
			cmd.addEventListener(CommandEvent.ERROR, unlock);
			cmd.execute();
		}
		
		/**
		 * Renames a list
		 */
		public function renameList(data:ListData, text:String):void {
			lock();
			var cmd:RenameListCmd = new RenameListCmd(data.id, text);
			cmd.addEventListener(CommandEvent.COMPLETE, listRequestComplete);
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
			_currentListName = "";
			_forceReload = _sortByDate != byDate || _kubesList > -1 || _top3Mode;
			_sortByDate = byDate;
			_top3Mode = false;
			_startIndex = 0;
			_length = _ITEMS_PER_PAGE * 2;
			_userName = "";
			_kubesList = -1;
			_data.clear();
			loadCubes();
		}
		
		/**
		 * Sets the current display index.
		 * The index represents the kubes at the right of the screen.
		 */
		public function setCurrentDisplayIndex(index:int):void {
			if(!_top3Mode && index + 9 > _startIndex + _length && index < _totalResults && !_locked) {
				_startIndex += _length;
				loadCubes();
			}
		}
		
		/**
		 * Shows the top 3
		 */
		public function showTop3():void {
			lock();
			_forceReload = !_top3Mode;
			_top3Mode = true;
			_startIndex = 0;
			_length = 3;
			_sortByDate = false;
			_userName = "";
			_kubesList = -1;
			_data.clear();
			loadCubes();
		}
		
		/**
		 * Loads the kubes of a specific user.
		 */
		public function searchKubesOfUser(userName:String):void {
			lock();
			_forceReload = _userName != userName;
			_openedCube = null;
			_userName = userName;
			_top3Mode = false;
			_sortByDate = true;
			_startIndex = 0;
			_length = _ITEMS_PER_PAGE * 2;
			_kubesList = -1;
			_data.clear();
			loadCubes();
		}
		
		/**
		 * Opens a list
		 */
		public function openList(id:int):void {
			lock();
			_forceReload = true;
			_forceReload = true;
			_top3Mode = false;
			_userName = "";
			_kubesList = id;
			_startIndex = 0;
			_length = 200;//hard limit not to explode server
			_data.clear();
			loadCubes();
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
		
		/**
		 * Shows the user's profile
		 */
		public function showProfile():void {
			lock();
			_openedCube = null;
			_userName = "";
			_top3Mode = false;
			_sortByDate = false;
			_profileMode = true;
			getLists();
		}
		
		
		/**
		 * Confirms the last stored action
		 */
		public function confirmAction():void {
			lock();
			_toConfirm.execute();
		}
		
		/**
		 * Cancels the last stored action
		 */
		public function cancelAction():void {
			if(_toConfirm is Disposable) Disposable(_toConfirm).dispose();
			_toConfirm = null;
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
			_currentListName = XML(event.data).child("listName")[0];
			_currentListAuthor = XML(event.data).child("listAuthor")[0];
			if(_data.length == 0) {
				_userName = "";
				if(_rerootToTop3) {
					_rerootToTop3 = false;
					showTop3();
				}else{
					unlock();
					throw new KubeException(Label.getLabel("noResults"), KubeExceptionLevel.WARNING);
				}
			}else{
				update();
				unlock();
			}
			_forceReload = false;
		}
		
		/**
		 * Called if kubes loading fails
		 */
		private function loadCubesErrorHandler(event:CommandEvent):void {
			_userName = "";
			if(_rerootToTop3) {
				_rerootToTop3 = false;
				showTop3();
			}
			unlock();
			_forceReload = false;
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
		 * Called when a kube deletion completes
		 */
		private function deleteCubeCompleteHandler(event:CommandEvent):void {
			loadCubes();
			throw(new KubeException(Label.getLabel("deleteSuccess"), KubeExceptionLevel.SUCCESS));
		}

		/**
		 * Called when a list is created
		 */
		private function listRequestComplete(event:CommandEvent):void {
			_lists = new ListDataCollection();
			_lists.populate(XML(event.data).child("lists")[0]);
			if(_rerootToStart) {
				start();
			}else{
				update();
				unlock();
			}
		}

		/**
		 * Called when a list is updated (added or removed kube)
		 */
		private function listUpdateHandler(event:CommandEvent):void {
			unlock();
			var label:String = UpdateListCmd(event.currentTarget).addMode? Label.getLabel("updateListAddSuccess") : Label.getLabel("updateListDelSuccess");
			if(_kubesList == UpdateListCmd(event.currentTarget).lid) {
				_forceReload = true;
				_data.clear();
				loadCubes();
			}
			throw(new KubeException(label, KubeExceptionLevel.SUCCESS));
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
			_locked = true;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.LOCK, this));
		}
		
		/**
		 * Tells the view that the model is unlocked
		 */
		private function unlock(...args):void {
			_locked = false;
			ViewLocator.getInstance().dispatchToViews(new KubeModelEvent(KubeModelEvent.UNLOCK, this));
		}
		
		/**
		 * Asks for confirmation
		 */
		private function askForConfirmation(cmd:Command):void {
			_toConfirm = cmd;
			dispatchEvent(new KubeModelEvent(KubeModelEvent.CONFIRM, this));
		}
		
	}
}