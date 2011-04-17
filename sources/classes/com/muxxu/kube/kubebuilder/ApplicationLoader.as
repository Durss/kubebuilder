package com.muxxu.kube.kubebuilder {
	import com.nurun.structure.environnement.EnvironnementManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * @author Francois
	 */
	public class ApplicationLoader extends MovieClip {
		private var _env:EnvironnementManager;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ApplicationLoader</code>.<br>
		 */
		public function ApplicationLoader() {
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
			stop();
			stage.align		= StageAlign.TOP_LEFT;
			stage.scaleMode	= StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			_env = new EnvironnementManager();
			_env.addVariables(stage.loaderInfo.parameters);
			_env.initialise(stage.loaderInfo.parameters["configXml"] || "xml/config.xml");
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Called on ENTER_FRAME event to update the progress bar.<br>
		 */
		private function enterFrameHandler(event:Event):void {
			graphics.clear();
			if(framesLoaded == totalFrames && loaderInfo.bytesLoaded == loaderInfo.bytesTotal && loaderInfo.bytesTotal > 1 && _env.complete) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				nextFrame();
				launch();
			} else {
				var w:int = 300; 
				var h:int = 6; 
				var percent:Number = (root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal) * .1;
				if(!isNaN(_env.bytesLoaded) && !isNaN(_env.bytesTotal) && _env.bytesTotal > 0) percent += _env.bytesLoaded/_env.bytesTotal * .9;
				var rect:Rectangle = new Rectangle(0,0,0,0);
				rect.x	= Math.round((stage.stageWidth - w) * .5);
				rect.y	= Math.round((stage.stageHeight - h) * .5);
				graphics.lineStyle(1, 0xffffff, 1, true);
				graphics.drawRect(rect.x, rect.y, w, h);
				
				graphics.lineStyle(0, 0xffffff, 0, true);
				graphics.beginFill(0xffffff, .5);
				graphics.drawRect(rect.x + 2, rect.y + 2, Math.round((w - 3) * percent), h - 3);
				graphics.endFill();
			}
		}
		
		/**
		 * Launch the application
		 */
		private function launch():void {
			// on frame 2
			var mainClass:Class = Class(getDefinitionByName("com.muxxu.kube.kubebuilder.Application"));
			if(mainClass) {
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}
}