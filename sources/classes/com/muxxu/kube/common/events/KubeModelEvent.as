package com.muxxu.kube.common.events {
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.model.events.ModelEvent;
	
	/**
	 * Event fired by models
	 * 
	 * @author Francois
	 */
	public class KubeModelEvent extends ModelEvent {
		
		static public const UPDATE:String = "onModelUpdate";
		static public const LOCK:String = "lockModel";
		static public const UNLOCK:String = "unlockModel";
		static public const CONFIRM:String = "confirmAction";
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeModelEvent</code>.
		 */
		public function KubeModelEvent(type:String, model:IModel, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, model, bubbles, cancelable);
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}