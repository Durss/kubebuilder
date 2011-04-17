package com.muxxu.kube.kubebuilder.views {
	import com.muxxu.kube.kubebuilder.controler.FrontControler;
	import com.nurun.components.form.events.FormComponentEvent;
	import gs.TweenLite;

	import com.muxxu.kube.kubebuilder.components.BackWindow;
	import com.muxxu.kube.kubebuilder.components.buttons.KBButton;
	import com.muxxu.kube.kubebuilder.components.form.SubmitForm;
	import com.muxxu.kube.kubebuilder.graphics.CheckIconGraphic;
	import com.muxxu.kube.kubebuilder.model.Model;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
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
	 */
	public class SubmitKubeView extends AbstractView {
		private var _openFormBt:KBButton;
		private var _backForm:BackWindow;
		private var _form:SubmitForm;
		private var _formCtn:Sprite;
		private var _disableLayer:Sprite;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SubmitKubeView</code>.
		 */
		public function SubmitKubeView() {
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
			var model:Model = event.model as Model;
			model;
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_openFormBt = addChild(new KBButton(Label.getLabel("openForm"), true, new CheckIconGraphic())) as KBButton;
			
			_disableLayer = new Sprite();
			_formCtn = new Sprite();
			_backForm = _formCtn.addChild(new BackWindow()) as BackWindow;
			_form = _formCtn.addChild(new SubmitForm()) as SubmitForm;
			
			_backForm.width = _form.width + 20;
			_backForm.height = _form.height + 20;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			_form.addEventListener(FormComponentEvent.SUBMIT, submitFormHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			_openFormBt.y = stage.stageHeight - _openFormBt.height - 10;
			PosUtils.hCenterIn(_openFormBt, stage);
			
			PosUtils.centerIn(_backForm, stage);
			PosUtils.centerIn(_form, stage);
		}
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _openFormBt) {
				//Draw the blured disable layer
				var bmd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
				bmd.draw(stage);
				bmd.applyFilter(bmd, bmd.rect, new Point(0,0), new BlurFilter(8,8,3));
				_disableLayer.graphics.clear();
				_disableLayer.graphics.beginBitmapFill(bmd);
				_disableLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageWidth);
				_disableLayer.graphics.endFill();
				
				_formCtn.alpha = 1;
				_disableLayer.alpha = 1;
				
				addChild(_disableLayer);
				addChild(_formCtn);
				TweenLite.from(_formCtn, .5, {blurFilter:{blurX:30, blurY:30, remove:true}, autoAlpha:0, delay: .25});
				TweenLite.from(_disableLayer, .5, {autoAlpha:0});
			}else if(event.target == _disableLayer) {
				closeForm();
			}
		}
		
		/**
		 * Called when the form is submitted.
		 */
		private function submitFormHandler(event:FormComponentEvent):void {
			FrontControler.getInstance().submit(_form.name, onPostComplete);
		}
		
		/**
		 * Called when kube posting completes
		 */
		private function onPostComplete():void {
			closeForm();
		}
		
		/**
		 * Closes the form.
		 */
		private function closeForm():void {
			TweenLite.to(_formCtn, .5, {blurFilter:{blurX:30, blurY:30, remove:true}, autoAlpha:0, removeChild:true});
			TweenLite.to(_disableLayer, .5, {autoAlpha:0, removeChild:true, delay: .25});
		}
	}
}