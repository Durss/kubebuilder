package com.muxxu.kube.hof {
	import com.muxxu.kube.common.AbstractApplication;
	import com.muxxu.kube.common.views.LockStateView;
	import com.muxxu.kube.hof.model.ModelHOF;
	import com.muxxu.kube.hof.views.EarthView;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;

	import flash.events.Event;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	 
	[SWF(width="870", height="500", backgroundColor="#4CA5CD", frameRate="31")]
	[Frame(factoryClass="com.muxxu.kube.hof.HallOfFameLoader")]
	public class HallOfFame extends AbstractApplication {
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.
		 */
		public function HallOfFame() {
			super(new ModelHOF());
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
		 * Initialize the class.
		 */
		override protected function initialize():void {
			super.initialize();
			
			FrontControlerKR.getInstance().initialize(_model);
			
			removeChild(_background);
			addChild(new EarthView());
			addChild(new LockStateView(_exceptionView));
		}
		
		/**
		 * Called when the stage is available.
		 * 
		 * Needed for a proper initial placement of the views. 
		 */
		override protected function addedToStageHandler(event:Event):void {
			super.addedToStageHandler(event);
			ModelHOF(_model).start();
		}
		
	}
}