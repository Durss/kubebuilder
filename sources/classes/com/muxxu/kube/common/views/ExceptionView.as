package com.muxxu.kube.common.views {
	import com.muxxu.kube.common.components.ScrollbarKube;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kubebuilder.graphics.ErrorWindowArrowGraphic;
	import com.nurun.components.button.BaseButton;
	import com.nurun.components.button.GraphicButton;
	import com.nurun.components.button.IconAlign;
	import com.nurun.components.button.visitors.CssVisitor;
	import com.nurun.components.button.visitors.applyDefaultFrameVisitorNoTween;
	import com.nurun.components.scroll.ScrollPane;
	import com.nurun.components.scroll.scrollable.ScrollableTextField;
	import com.nurun.components.text.CssTextField;
	import com.nurun.components.vo.Margin;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.nurun.utils.pos.PosUtils;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.system.System;
	import gs.TweenLite;



	/**
	 * 
	 * @author Francois 
	 * @date 16 nov. 2010;
	 */
	public class ExceptionView extends AbstractView {

		private var _background:Shape;
		private var _title:CssTextField;
		private var _description:ScrollableTextField;
		private var _scrollpane:ScrollPane;
		private var _splitter:GraphicButton;
		private var _opened:Boolean;
		private var _container:Sprite;
		private var _disableLayer:Sprite;
		private var _copy:BaseButton;
		private var _lastMessage:String;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ExceptionView</code>.
		 */
		public function ExceptionView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			event;//Prevents from unused warnings on FDT
			ViewLocator.getInstance().removeView(this);
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_disableLayer= addChild(new Sprite()) as Sprite;
			_container	= addChild(new Sprite()) as Sprite;
			_background	= _container.addChild(new Shape()) as Shape;
			_title		= _container.addChild(new CssTextField("errorWindowTitle")) as CssTextField;
			_copy		= _container.addChild(new ButtonKube("COPY ERROR TO CLIPBOARD")) as BaseButton;
			
			var back:Shape = new Shape();
			back.graphics.beginFill(0xff0000, 0);
			back.graphics.drawRect(0, 0, 100, 9);
			back.graphics.beginFill(0xDDDDDD, 1);
			back.graphics.drawRect(0, 4, 100, 1);
			back.graphics.endFill();
			_splitter	= _container.addChild(new GraphicButton(back, new ErrorWindowArrowGraphic())) as GraphicButton;
			_description= new ScrollableTextField("", "errorWindowDescription");
			_scrollpane = _container.addChild(new ScrollPane(_description, new ScrollbarKube(), new ScrollbarKube())) as ScrollPane;
			
			applyDefaultFrameVisitorNoTween(_copy, _copy.background);
			
			MovieClip(_splitter.icon).stop();
			_scrollpane.width = 400;
			_scrollpane.height = 0;
			_scrollpane.autoHideScrollers = true;
			
			_splitter.width = 400;
			_splitter.iconAlign = IconAlign.CENTER;
			_title.width = 400;
			_title.wordWrap = true;
			_copy.contentMargin = new Margin(5, 5, 5, 5);
			_copy.accept(new CssVisitor());
			_title.selectable = true;
			_description.selectable = true;
			_description.autoWrap = false;
			_description.wordWrap = false;
			
			_background.graphics.beginFill(0x428DAC, 1);
			_background.graphics.drawRect(0, 0, 100, 100);
			_background.graphics.endFill();
			
			_background.filters = [new DropShadowFilter(0,0,0,.35,10,10,1,3)];
			
			_disableLayer.graphics.beginFill(0, .5);
			_disableLayer.graphics.drawRect(0, 0, 100, 100);
			_disableLayer.graphics.endFill();
			
			visible = false;
			alpha = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_copy.addEventListener(MouseEvent.CLICK, clickCopyHandler);
			_splitter.addEventListener(MouseEvent.CLICK, clickSplitterHandler);
			_disableLayer.addEventListener(MouseEvent.CLICK, clickDisableLayerHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			var globalErrorHandling:Boolean = true;
			try {
				root.loaderInfo.uncaughtErrorEvents;
			}catch(e:Error){
				globalErrorHandling = false;
			}
			if(globalErrorHandling) {
				loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError", uncaughExceptionHandler);
				root.loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError", uncaughExceptionHandler);
			}
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
		/**
		 * Called when an uncaugh exception is detected
		 */
		private function uncaughExceptionHandler(event:Event):void {
			event.preventDefault();
			var message:String = event["error"] is Error ? (event["error"] as Error).getStackTrace() : event["error"];
			
			_title.text = message.split(/\n/gi, 1)[0];
			if(message.length > _title.text.length) {
				_splitter.visible = true;
				_description.text = message.substr(_title.text.length + 1);
			} else {
				_splitter.visible = false;
				_scrollpane.height = 0;
			}
			
			_lastMessage = message;
			_description.vPercent = 0;
			_description.hPercent = 0;
			
			TweenLite.to(this, .25, {autoAlpha:1});
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			var margin:int = 10;
			_scrollpane.validate();
			_scrollpane.visible = _scrollpane.height > 0;
			
			_disableLayer.width = stage.stageWidth;
			_disableLayer.height = stage.stageHeight;
			
			_title.y = margin;
			_title.x = _scrollpane.x = _splitter.x = margin;
			
			PosUtils.vPlaceNext(5, _title, _splitter, _scrollpane, _copy);
			PosUtils.hCenterIn(_copy, _scrollpane);

			_background.width = 400 + margin * 2;
			_background.height = Math.round(_copy.y + _copy.height + margin * 2);
			
			if(stage != null) {
				PosUtils.centerInStage(_container);
			}
			_scrollpane.graphics.clear();
			_scrollpane.graphics.beginFill(0xffffff, .5);
			_scrollpane.graphics.drawRect(0, 0, _scrollpane.width, _scrollpane.height);
			_scrollpane.graphics.endFill();
		}
		
		/**
		 * Called when copy to clipboard button is clicked
		 */
		private function clickCopyHandler(event:MouseEvent):void {
			System.setClipboard(_lastMessage);
		}
		
		/**
		 * Called when the bar is clicked.
		 */
		private function clickSplitterHandler(event:MouseEvent):void {
			_opened = !_opened;
			MovieClip(_splitter.icon).gotoAndStop(_opened? 2 : 1);
			TweenLite.to(_scrollpane, .25, {height:_opened? 200 : 0, onUpdate:computePositions});
		}
		
		/**
		 * Called when the disable layer is clicked
		 */
		private function clickDisableLayerHandler(event:MouseEvent):void {
			TweenLite.to(this, .25, {autoAlpha:0});
		}
		
	}
}