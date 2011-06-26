package com.muxxu.kube.kuberank {
	import com.muxxu.kube.common.AbstractApplication;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.views.ConfirmWindowView;
	import com.muxxu.kube.kuberank.views.DisableLayerView;
	import com.muxxu.kube.kuberank.views.LastKubesView;
	import com.muxxu.kube.kuberank.views.ListsView;
	import com.muxxu.kube.kuberank.views.LockStateView;
	import com.muxxu.kube.kuberank.views.MenuView;
	import com.muxxu.kube.kuberank.views.SingleKubeView;
	import com.muxxu.kube.kuberank.views.SmoothListView;
	import com.muxxu.kube.kuberank.views.Top3View;
	import flash.events.Event;


	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 */
	 
	[SWF(width="870", height="480", backgroundColor="#4CA5CD", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.kuberank.KubeRankLoader")]
	public class KubeRank extends AbstractApplication {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.<br>
		 */
		public function KubeRank() {
			super(new ModelKR());
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
			
			FrontControlerKR.getInstance().initialize(_model);
			
			addChild(new LastKubesView());
			addChild(new Top3View());
//			addChild(new ListView());
			addChild(new SmoothListView());
			addChild(new MenuView());
			addChild(new ListsView());
			addChild(new DisableLayerView());
			addChild(new SingleKubeView());
			addChild(new ConfirmWindowView());
			addChild(new LockStateView(_exceptionView));
		}
		
		/**
		 * Called when the stage is available.
		 * 
		 * Needed for a proper initial placement of the views. 
		 */
		override protected function addedToStageHandler(event:Event):void {
			super.addedToStageHandler(event);
			ModelKR(_model).start();
		}
		
	}
}