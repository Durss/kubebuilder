package com.muxxu.kube.kubebuilder {
	import com.muxxu.kube.kubebuilder.controler.FrontControler;
	import com.muxxu.kube.kubebuilder.model.Model;
	import com.muxxu.kube.kubebuilder.views.EditorView;
	import com.muxxu.kube.kubebuilder.views.KubeView;
	import com.muxxu.kube.kubebuilder.views.PanelView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 */
	 
	[SWF(width="800", height="500", backgroundColor="#4CA5CD", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.kubebuilder.ApplicationLoader")]
	public class Application extends MovieClip {
		private var _model:Model;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.<br>
		 */
		public function Application() {
			initialize();
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
		/**
		 * Initialize the class.<br>
		 */
		private function initialize():void {
			_model = new Model();
			ViewLocator.getInstance().initialise(_model);
			FrontControler.getInstance().initialize(_model);
			
			addChild(new KubeView());
			addChild(new PanelView());
			addChild(new EditorView());
//			addChild(new Stats());
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 * 
		 * Needed for a proper initial placement of the views. 
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_model.start();
		}
		
	}
}