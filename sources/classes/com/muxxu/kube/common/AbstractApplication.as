package com.muxxu.kube.common {
	import com.muxxu.kube.common.views.ExceptionView;
	import gs.plugins.ColorMatrixFilterPlugin;
	import gs.plugins.RemoveChildPlugin;
	import gs.plugins.TweenPlugin;

	import net.hires.debug.Stats;

	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.nurun.utils.input.keyboard.KeyboardSequenceDetector;
	import com.nurun.utils.input.keyboard.events.KeyboardSequenceEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 * @author Francois
	 */
	public class AbstractApplication extends MovieClip {
		
		protected var _stats:Stats;
		protected var _ks:KeyboardSequenceDetector;
		protected var _model:IModel;
		private var _exceptionView:ExceptionView;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>AbstractApplication</code>.
		 */
		public function AbstractApplication(model:IModel) {
			_model = model;
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
		protected function initialize():void {
			TweenPlugin.activate([ColorMatrixFilterPlugin, RemoveChildPlugin]);
			
			ViewLocator.getInstance().initialise(_model);
			
			_stats = new Stats();
			_exceptionView = new ExceptionView();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 * 
		 * Needed for a proper initial placement of the views. 
		 */
		protected function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_ks = new KeyboardSequenceDetector(stage);
			_ks.addSequence("stats", KeyboardSequenceDetector.STATS_CODE);
			_ks.addEventListener(KeyboardSequenceEvent.SEQUENCE, keySequenceHandler);
			
			addChild(_exceptionView);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		/**
		 * Called when the stage is resized.
		 * Draws a backgroud, that the blured disable layer created when opening
		 * a popin won't be blured only from the edge of the views but from the
		 * borders of the application.
		 */
		protected function resizeHandler(event:Event = null):void {
			graphics.clear();
			graphics.beginFill(0x4CA5CD, 1);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		/**
		 * Called when a keyboard sequence is detected.
		 */
		protected function keySequenceHandler(event:KeyboardSequenceEvent):void {
			if(contains(_stats)) {
				removeChild(_stats);
			}else{
				addChild(_stats);
			}
		}
		
	}
}