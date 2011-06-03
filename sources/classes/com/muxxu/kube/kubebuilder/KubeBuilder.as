package com.muxxu.kube.kubebuilder {
	import com.muxxu.kube.kubebuilder.views.InfoView;
	import com.muxxu.kube.common.AbstractApplication;
	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.muxxu.kube.kubebuilder.model.ModelKB;
	import com.muxxu.kube.kubebuilder.views.EditorView;
	import com.muxxu.kube.kubebuilder.views.KubeView;
	import com.muxxu.kube.kubebuilder.views.PanelView;
	import com.muxxu.kube.kubebuilder.views.SubmitKubeView;
	import com.nurun.structure.environnement.configuration.Config;

	import flash.events.Event;


	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 */
	 
	[SWF(width="870", height="500", backgroundColor="#4CA5CD", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.kubebuilder.KubeBuilderLoader")]
	public class KubeBuilder extends AbstractApplication {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.<br>
		 */
		public function KubeBuilder() {
			super(new ModelKB());
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
		override protected function initialize():void {
			super.initialize();
			
			FrontControlerKB.getInstance().initialize(_model);
			
			addChild(new KubeView());
			addChild(new PanelView());
			addChild(new EditorView());
			addChild(new SubmitKubeView());
			if(!Config.getBooleanVariable("infosRead")) {
				addChild(new InfoView());
			}
		}
		
		/**
		 * Called when the stage is available.
		 * 
		 * Needed for a proper initial placement of the views. 
		 */
		override protected function addedToStageHandler(event:Event):void {
			super.addedToStageHandler(event);
			ModelKB(_model).start();
		}
		
	}
}