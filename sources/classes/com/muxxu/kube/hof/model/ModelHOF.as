package com.muxxu.kube.hof.model {
	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	public class ModelHOF extends EventDispatcher implements IModel {
		private var _locked:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ModelHOF</code>.
		 */
		public function ModelHOF() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Starts the application
		 */
		public function start():void {
			update();
			unlock();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			
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
		
	}
}