package com.muxxu.kube.kubebuilder.views {
	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import flash.events.MouseEvent;
	import com.nurun.components.vo.Margin;
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.BackWindow;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.structure.mvc.views.ViewLocator;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	/**
	 * 
	 * @author Francois
	 * @date 3 juin 2011;
	 */
	public class InfoView extends AbstractView {
		private var _background:BackWindow;
		private var _label:CssTextField;
		private var _holder:Sprite;
		private var _readBt:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>InfoView</code>.
		 */
		public function InfoView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			event;//prevent from unused wrnings from FDT
			ViewLocator.getInstance().removeView(this);
			TweenLite.to(this, .5, {y:0, delay:.5, ease:Sine.easeOut});
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
			_background = addChild(new BackWindow()) as BackWindow;
			_holder = addChild(new Sprite()) as Sprite;
			_label = _holder.addChild(new CssTextField("readInfoLabel")) as CssTextField;
			_readBt = _holder.addChild(new ButtonKube(Label.getLabel("readInfoButton"), false, null, true)) as ButtonKube;
			
			_readBt.contentMargin = new Margin(5, 2, 5, 2);
			
			_label.text = Label.getLabel("readInfo");
			filters = [new DropShadowFilter(2,90,0,.4,5,5,1,3)];
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_readBt.addEventListener(MouseEvent.CLICK, clickReadHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
			y = -height - 10;
		}
		
				
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions(event:Event = null):void {
			PosUtils.centerIn(_readBt, _label);
			var margin:int = BackWindow.CELL_WIDTH + 5;
			_label.x = _label.y = margin;
			_readBt.y = Math.round(_label.y + _label.height);
			_background.width = _label.width + margin * 2;
			_background.height = Math.round(_readBt.y + _readBt.height + margin);
			
			PosUtils.centerInStage(this);
		}
		
		/**
		 * Called when read button is clicked.
		 */
		private function clickReadHandler(event:MouseEvent):void {
			FrontControlerKB.getInstance().readInfos();
		}
		
	}
}