package com.muxxu.kube.kuberank.views {
	import flash.display.DisplayObject;
	import com.muxxu.kube.common.views.ExceptionView;
	import gs.TweenLite;

	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author Francois
	 */
	public class LockStateView extends AbstractView {
		private var _locked:Boolean;
		private var _exceptionView:ExceptionView;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>LockStateView</code>.
		 */
		public function LockStateView(exceptionView:ExceptionView) {
			_exceptionView = exceptionView;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		override public function update(event:IModelEvent):void {
			
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			ViewLocator.getInstance().addEventListener(KubeModelEvent.LOCK, lockStateChangeHandler);
			ViewLocator.getInstance().addEventListener(KubeModelEvent.UNLOCK, lockStateChangeHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			stage.addEventListener(MouseEvent.CLICK,				inputEventHandler, false, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,			inputEventHandler, false, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_UP,				inputEventHandler, false, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,			inputEventHandler, false, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_OVER,			inputEventHandler, false, 0xff);
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,		inputEventHandler, false, 0xff);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,	inputEventHandler, false, 0xff);
			stage.addEventListener(FocusEvent.FOCUS_OUT,			inputEventHandler, false, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,			inputEventHandler, false, 0xff);
			stage.addEventListener(KeyboardEvent.KEY_UP,			inputEventHandler, false, 0xff);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,			inputEventHandler, false, 0xff);
			
			stage.addEventListener(MouseEvent.CLICK,				inputEventHandler, true, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,			inputEventHandler, true, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_UP,				inputEventHandler, true, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,			inputEventHandler, true, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_OVER,			inputEventHandler, true, 0xff);
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,		inputEventHandler, true, 0xff);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,	inputEventHandler, true, 0xff);
			stage.addEventListener(FocusEvent.FOCUS_OUT,			inputEventHandler, true, 0xff);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,			inputEventHandler, true, 0xff);
			stage.addEventListener(KeyboardEvent.KEY_UP,			inputEventHandler, true, 0xff);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,			inputEventHandler, true, 0xff);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			graphics.clear();
			graphics.beginFill(0, .5);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		/**
		 * Called when lock state changes
		 */
		private function lockStateChangeHandler(event:KubeModelEvent):void {
			_locked = event.type == KubeModelEvent.LOCK;
			TweenLite.to(this, .25, {autoAlpha:_locked? 1: 0});
		}
		
		/**
		 * Called when an input (mouse/keyboard) event occurs
		 */
		private function inputEventHandler(event:Event):void {
			if(_locked && !_exceptionView.contains(event.target as DisplayObject)) {
				event.stopPropagation();
				event.preventDefault();
			}
		}
		
	}
}