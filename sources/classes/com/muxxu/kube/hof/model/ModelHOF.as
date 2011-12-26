package com.muxxu.kube.hof.model {
	import com.muxxu.kube.hof.cmd.LoadHOFCmd;
	import com.muxxu.kube.hof.vo.HOFDataCollection;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.core.commands.events.CommandEvent;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	public class ModelHOF extends ModelKR {
		
		private var _loadDataCmd:LoadHOFCmd;
		private var _data:HOFDataCollection;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ModelHOF</code>.
		 */
		public function ModelHOF() {
			super();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get hofData():HOFDataCollection { return _data; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Starts the application
		 */
		override public function start():void {
			lock();
			_loadDataCmd = new LoadHOFCmd();
			_loadDataCmd.addEventListener(CommandEvent.COMPLETE, loadCompleteHandler);
			_loadDataCmd.execute();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
		/**
		 * Called when HOF data loading completes.
		 */
		private function loadCompleteHandler(event:CommandEvent):void {
			_data = new HOFDataCollection();
			_data.populate(event.data as XML);
			getLists();
		}		
	}
}