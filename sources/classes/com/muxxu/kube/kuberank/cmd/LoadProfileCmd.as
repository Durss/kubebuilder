package com.muxxu.kube.kuberank.cmd {
	import com.muxxu.kube.common.error.KubeExceptionLevel;
	import com.muxxu.kube.common.error.KubeException;
	import com.nurun.core.commands.Command;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.commands.LoadFileCmd;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;

	/**
	 * The LoadProfileCmd is a concrete implementation of the ICommand interface.
	 * Its responsability is to load a list of submitted cubes.
	 *
	 * @author Francois
	 * @date 24 avr. 2011;
	 */
	public class LoadProfileCmd extends LoadFileCmd implements Command {
		
		/**
		 * Constructor
		 */
		public function  LoadProfileCmd(wsUrl:String, uid:String) {
			super(wsUrl);
			_urlVariables["uid"] = uid;
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
				throw new KubeException(Label.getLabel("errorLoadProfileResultFormat"), KubeExceptionLevel.ERROR);
			}
			
			var result:String = data.child("result")[0];
			if(result == "0") {
				dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, data));
			}else{
				dispatchEvent(new CommandEvent(CommandEvent.ERROR));
				throw new KubeException(Label.getLabel("errorLoadProfileResult"+result), KubeExceptionLevel.ERROR);
			}
		}
		
		/**
		 * Called if loading fails.
		 */
		override protected function loadErrorHandler(event:IOErrorEvent):void {
			super.loadErrorHandler(event);
			throw new KubeException(Label.getLabel("errorLoadProfileResult404"), KubeExceptionLevel.ERROR);
		}
	}
}
