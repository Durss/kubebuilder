package com.muxxu.kube.hof.views {
	import gs.TweenLite;

	import com.muxxu.kube.kubebuilder.graphics.HOFTutorialGraphic;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 déc. 2011;
	 */
	public class CursorView extends AbstractView {
		private var _tuto:HOFTutorialGraphic;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CursorView</code>.
		 */
		public function CursorView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			event;//Prevents from unused warning
			
			TweenLite.to(_tuto, .25, {autoAlpha:1, onComplete:_tuto.play, delay:.5});
			
			ViewLocator.getInstance().removeView(this);
			
			stage.addEventListener(MouseEvent.CLICK, interruptTutoHandler);
		}

		private function interruptTutoHandler(event:MouseEvent):void {
			onTutoComplete();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_tuto = addChild(new HOFTutorialGraphic()) as HOFTutorialGraphic;
			_tuto.alpha = 0;
			_tuto.visible = false;
			
			_tuto.addFrameScript(_tuto.totalFrames-1, onTutoComplete);
			_tuto.stop();
		}

		private function onTutoComplete():void {
			_tuto.stop();
			TweenLite.to(_tuto, .25, {autoAlpha:0, removeChild:true});
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		private function mouseMoveHandler(event:MouseEvent):void {
			var limit:Number = (Math.abs(mouseX - stage.stageWidth * .5)/(stage.stageWidth * .5))*135 + 280;
			if(mouseY > limit){
				Mouse.cursor = MouseCursor.HAND;
			}else{
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
	}
}