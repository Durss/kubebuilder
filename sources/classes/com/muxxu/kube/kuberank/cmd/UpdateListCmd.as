package com.muxxu.kube.kuberank.cmd {
	import com.muxxu.kube.common.error.KubeException;
	import com.muxxu.kube.common.error.KubeExceptionLevel;
	import com.nurun.core.commands.Command;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.commands.LoadFileCmd;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;

	/**
	 * The  VoteCmd is a concrete implementation of the ICommand interface.
	 * Its responsability is to load a list of submitted cubes.
	 *
	 * @author Francois
	 * @date 24 avr. 2011;
	 */
	public class UpdateListCmd extends LoadFileCmd implements Command {
		
		private var _addMode:Boolean;
		private var _lid:int;


		/**
		 * Constructor
		 */
		public function UpdateListCmd(kid:int, lid:int, addMode:Boolean) {
			_lid = lid;
			_addMode = addMode;
			super(Config.getPath("updateList"));
			_urlVariables["kid"] = kid.toString();
			_urlVariables["lid"] = lid.toString();
			_urlVariables["act"] = addMode? "add" : "del";
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
				throw new KubeException(Label.getLabel("errorUpdateListResultFormat"), KubeExceptionLevel.ERROR);
			}
			var result:String = data.child("result")[0];
			if(result == "0") {
				dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, data));
			}else{
				dispatchEvent(new CommandEvent(CommandEvent.ERROR));
				throw new KubeException(Label.getLabel("errorUpdateListResult"+result), KubeExceptionLevel.ERROR);
			}
		}
		
		/**
		 * Called if loading fails.
		 */
		override protected function loadErrorHandler(event:IOErrorEvent):void {
			super.loadErrorHandler(event);
			throw new KubeException(Label.getLabel("errorUpdateListResult404"), KubeExceptionLevel.ERROR);
		}

		public function get addMode():Boolean {
			return _addMode;
		}

		public function get lid():int {
			return _lid;
		}

	}
}
