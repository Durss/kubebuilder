package com.muxxu.kube.kubebuilder {
	import gs.plugins.RemoveChildPlugin;
	import com.muxxu.kube.kubebuilder.views.SubmitKubeView;
	import com.muxxu.kube.kubebuilder.views.ExceptionView;
	import com.nurun.utils.input.keyboard.events.KeyboardSequenceEvent;
	import com.nurun.utils.input.keyboard.KeyboardSequenceDetector;
	import net.hires.debug.Stats;
	import gs.plugins.ColorMatrixFilterPlugin;
	import gs.plugins.TweenPlugin;
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
	[Frame(factoryClass="com.muxxu.kube.kubebuilder.KubeBuilderLoader")]
	public class KubeBuilder extends MovieClip {
		private var _model:Model;
		private var _stats:Stats;
		private var _ks:KeyboardSequenceDetector;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.<br>
		 */
		public function KubeBuilder() {
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
			TweenPlugin.activate([ColorMatrixFilterPlugin, RemoveChildPlugin]);
			
			_model = new Model();
			ViewLocator.getInstance().initialise(_model);
			FrontControler.getInstance().initialize(_model);
			
			addChild(new KubeView());
			addChild(new PanelView());
			addChild(new EditorView());
			addChild(new SubmitKubeView());
			addChild(new ExceptionView());
			_stats = new Stats();
			
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
			_ks = new KeyboardSequenceDetector(stage);
			_ks.addSequence("stats", KeyboardSequenceDetector.STATS_CODE);
			_ks.addEventListener(KeyboardSequenceEvent.SEQUENCE, keySequenceHandler);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		/**
		 * Called when the stage is resized.
		 * Draws a backgroud, that the blured disable layer created when opening
		 * a popin won't be blured only from the edge of the views but from the
		 * borders of the application.
		 */
		private function resizeHandler(event:Event = null):void {
			graphics.clear();
			graphics.beginFill(0x4CA5CD, 1);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		/**
		 * Called when a keyboard sequence is detected.
		 */
		private function keySequenceHandler(event:KeyboardSequenceEvent):void {
			if(contains(_stats)) {
				removeChild(_stats);
			}else{
				addChild(_stats);
			}
		}
		
	}
}