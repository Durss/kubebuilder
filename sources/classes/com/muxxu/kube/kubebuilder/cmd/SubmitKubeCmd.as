package com.muxxu.kube.kubebuilder.cmd {
	import com.muxxu.kube.common.error.KubeException;
	import com.muxxu.kube.common.error.KubeExceptionLevel;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.core.commands.Command;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.commands.LoadFileCmd;

	import mx.utils.Base64Encoder;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;



	/**
	 * The  SubmitKubeCmd is a concrete implementation of the ICommand interface.
	 * Its responsability is to sumbit a kube to the data base.
	 *
	 * @author Francois
	 * @date 18 avr. 2011;
	 */
	public class SubmitKubeCmd extends LoadFileCmd implements Command {
		
		private var _kubeName:String;

		/**
		 * Constructor
		 */
		public function SubmitKubeCmd(wsUrl:String, kubeName:String, data:KUBData) {
			_kubeName = kubeName;
			super(wsUrl);
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(data.toByteArray());
			_urlVariables["name"] = _kubeName;
			_urlVariables["kube"] = encoder.drain();
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
				throw new Error(Label.getLabel("errorSubmitResultFormat"));
			}
			var result:String = data.child("result")[0];
			if(result == "0") {
				dispatchEvent(new CommandEvent(CommandEvent.COMPLETE, result));
			}else{
				dispatchEvent(new CommandEvent(CommandEvent.ERROR));
				throw new KubeException(Label.getLabel("errorSubmitResult"+result), KubeExceptionLevel.ERROR);
			}
		}
		
		/**
		 * Called if loading fails.
		 */
		override protected function loadErrorHandler(event:IOErrorEvent):void {
			super.loadErrorHandler(event);
			throw new KubeException(Label.getLabel("errorSubmitResult404"), KubeExceptionLevel.ERROR);
		}
		
	}
}
