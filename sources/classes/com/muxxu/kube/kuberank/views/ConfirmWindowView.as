package com.muxxu.kube.kuberank.views {
	import com.nurun.structure.environnement.label.Label;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import gs.TweenLite;

	import com.muxxu.kube.common.components.BackWindow;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.common.events.KubeModelEvent;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;



	/**
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	public class ConfirmWindowView extends AbstractView {
		private var _confirmBt:ButtonKube;
		private var _cancelBt:ButtonKube;
		private var _background:BackWindow;
		private var _opened:Boolean;
		private var _holder:Sprite;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ConfirmWindowView</code>.
		 */
		public function ConfirmWindowView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			var model:IModel = event.model;
			model.addEventListener(KubeModelEvent.CONFIRM, confirmActionHandler);
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
			alpha = 0;
			visible = false;
			
			_holder = addChild(new Sprite()) as Sprite;
			_background = _holder.addChild(new BackWindow()) as BackWindow;
			_confirmBt = _holder.addChild(new ButtonKube(Label.getLabel("confirm"), true)) as ButtonKube;
			_cancelBt = _holder.addChild(new ButtonKube(Label.getLabel("cancel"), true, null, true)) as ButtonKube;
			
			_confirmBt.x = _cancelBt.x = _confirmBt.y = BackWindow.CELL_WIDTH;
			_confirmBt.y ++;
			_cancelBt.y = Math.round(_confirmBt.y + _confirmBt.height + 1);
			_cancelBt.width = _confirmBt.width = Math.round(Math.max(_cancelBt.width, _confirmBt.width) + 5);
			_background.width = _cancelBt.width + BackWindow.CELL_WIDTH*2;
			_background.height = Math.round(_cancelBt.y + _cancelBt.height + BackWindow.CELL_WIDTH + 1);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, render);
			stage.addEventListener(MouseEvent.CLICK, clickHandler, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
			render();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function render(event:Event = null):void {
			if(!_opened) return;
			
			PosUtils.centerInStage(_holder);
			trace("ConfirmWindowView.render(event)");
			visible = false;
			var bmd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			bmd.draw(stage);
			bmd.applyFilter(bmd, bmd.rect, new Point(0,0), new BlurFilter(8,8,3));
			graphics.clear();
			graphics.beginBitmapFill(bmd);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
//			bmd.dispose();
			visible = true;
		}
		
		/**
		 * Called when model asks for a confirmation
		 */
		private function confirmActionHandler(event:KubeModelEvent):void {
			_opened = true;
			render();
			TweenLite.to(this, .25, {autoAlpha:1});
		}
		
		/**
		 * Called when a button is clicked
		 */
		private function clickHandler(event:Event):void {
			if(!_opened) return;
			
			event.stopPropagation();
			
			if(event.target == _confirmBt || (event is KeyboardEvent && KeyboardEvent(event).keyCode == Keyboard.ENTER)) {
				FrontControlerKR.getInstance().confirmAction();
			}else{
				FrontControlerKR.getInstance().cancelAction();
			}
			_opened = false;
			TweenLite.to(this, .25, {autoAlpha:0});
		}
		
		/**
		 * Called when a key is released
		 */
		private function keyUpHandler(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.ENTER) {
				clickHandler(event);
			}
		}
		
	}
}