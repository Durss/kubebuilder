package com.muxxu.kube.kuberank.cmd {
	import com.nurun.core.commands.Command;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.commands.LoadFileCmd;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;

	/**
	 * The  LoadCubesCmd is a concrete implementation of the ICommand interface.
	 * Its responsability is to load a list of submitted cubes.
	 *
	 * @author Francois
	 * @date 24 avr. 2011;
	 */
	public class LoadCubesCmd extends LoadFileCmd implements Command {
		
		private var _startIndex:int;
		private var _length:int;

		/**
		 * Constructor
		 */
		public function  LoadCubesCmd(wsUrl:String, startIndex:int = 0, length:int = 50, userName:String = "", orderByDate:Boolean = false) {
			_length = length;
			_startIndex = startIndex;
			super(wsUrl);
			_urlVariables["start"] = _startIndex;
			_urlVariables["length"] = _length;
			if(userName.length > 0) {
				_urlVariables["userName"] = userName;
			}
			if(orderByDate) {
				_urlVariables["orderBy"] = "date";
			}
		}

		/**
		 * Can be used to dispatch the CommandEvent.COMPLETE event asynchronously
		 * and / or to execute some method after retrieving some data.
		 */
		override protected function loadCompleteHandler(event:Event = null):void {
			var data:XML;
			try {
				data = new XML(URLLoader(event.target).data);
			}catch(error:Error) {
				dispatchEvent(new CommandEvent(CommandEvent.ERROR));
				throw new Error(Label.getLabel("errorLoadResultFormat"));
			}
			var result:String = data.child("result")[0];
			if(result == "0") {
				dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, data));
			}else{
				dispatchEvent(new CommandEvent(CommandEvent.ERROR));
				throw new Error(Label.getLabel("errorLoadResult"+result));
			}
		}
		
		/**
		 * Called if loading fails.
		 */
		override protected function loadErrorHandler(event:IOErrorEvent):void {
			super.loadErrorHandler(event);
			throw new Error(Label.getLabel("errorLoadResult404"));
		}
	}
}
