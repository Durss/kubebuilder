package com.muxxu.kube.kubebuilder.views {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.BackWindow;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.common.components.tooltip.ToolTip;
	import com.muxxu.kube.common.components.tooltip.content.TTTextContent;
	import com.muxxu.kube.common.vo.ToolTipMessage;
	import com.muxxu.kube.kubebuilder.components.form.SubmitForm;
	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.muxxu.kube.kubebuilder.graphics.CheckIconGraphic;
	import com.muxxu.kube.kubebuilder.model.ModelKB;
	import com.nurun.components.form.events.FormComponentEvent;
	import com.nurun.components.vo.Margin;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;


	
	/**
	 * Displays the submit button at the bottom and contains the submit form
	 * 
	 * @author Francois
	 */
	public class SubmitKubeView extends AbstractView {
		private var _openFormBt:ButtonKube;
		private var _backForm:BackWindow;
		private var _form:SubmitForm;
		private var _formCtn:Sprite;
		private var _disableLayer:Sprite;
		private var _downloadBt:ButtonKube;
		private var _uploadBt:ButtonKube;
		private var _buttonsHolder:Sprite;
		private var _tooltip:ToolTip;
		private var _ttContent:TTTextContent;
		private var _ttMessage:ToolTipMessage;
		
		
		
		
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
			var model:ModelKB = event.model as ModelKB;
			if(model.kubeSubmitted) {
				TweenLite.to(this, .25, {autoAlpha:0});
				_form.enable();
			}
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_buttonsHolder = addChild(new Sprite()) as Sprite;
			_openFormBt = _buttonsHolder.addChild(new ButtonKube(Label.getLabel("openForm"), true, new CheckIconGraphic())) as ButtonKube;
			_openFormBt.contentMargin = new Margin(10, 5, 10, 5);
			
			_downloadBt = _buttonsHolder.addChild(new ButtonKube(Label.getLabel("downloadKub"), false)) as ButtonKube;
			_downloadBt.contentMargin = new Margin(10, 5, 10, 5);
			
			_uploadBt = _buttonsHolder.addChild(new ButtonKube(Label.getLabel("uploadKub"), false)) as ButtonKube;
			_uploadBt.contentMargin = new Margin(10, 5, 10, 5);
			
			_tooltip = addChild(new ToolTip()) as ToolTip;
			_ttContent = new TTTextContent();
			_ttMessage = new ToolTipMessage(_ttContent, null);
			
			_disableLayer = new Sprite();
			_formCtn = new Sprite();
			_backForm = _formCtn.addChild(new BackWindow()) as BackWindow;
			_form = _formCtn.addChild(new SubmitForm()) as SubmitForm;
			
			_backForm.width = _form.width + 20;
			_backForm.height = _form.height + 20;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_form.addEventListener(FormComponentEvent.SUBMIT, submitFormHandler);
		}

		private function mouseOverHandler(event:MouseEvent):void {
			var text:String;
			if(event.target == _downloadBt) {
				text = Label.getLabel("tooltipSave");
			}else if(event.target == _uploadBt) {
				text = Label.getLabel("tooltipLoad");
			}else if(event.target == _openFormBt) {
				text = Label.getLabel("tooltipSubmit");
			}
			if(text != null) {
				_ttContent.populate(text);
				_ttMessage.target = event.target as InteractiveObject;
				_tooltip.open(_ttMessage);
			}
		}

		private function mouseOutHandler(event:MouseEvent):void {
			_tooltip.close();
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
			PosUtils.vAlign(PosUtils.V_ALIGN_BOTTOM, 0, _downloadBt, _openFormBt, _uploadBt);
			PosUtils.hPlaceNext(10, _downloadBt, _openFormBt, _uploadBt);
			PosUtils.hCenterIn(_buttonsHolder, stage);
			_buttonsHolder.y = stage.stageHeight - _buttonsHolder.height - 10;
			
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
				_disableLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_disableLayer.graphics.endFill();
				
				_formCtn.alpha = 1;
				_disableLayer.alpha = 1;
				
				addChild(_disableLayer);
				addChild(_formCtn);
				TweenLite.from(_formCtn, .5, {blurFilter:{blurX:30, blurY:30, remove:true}, autoAlpha:0, delay: .25});
				TweenLite.from(_disableLayer, .5, {autoAlpha:0});
				
				_form.setFocus();
			}else if(event.target == _disableLayer) {
				closeForm();
			}else if(event.target == _downloadBt) {
				FrontControlerKB.getInstance().downloadKub();
			}else if(event.target == _uploadBt) {
				FrontControlerKB.getInstance().uploadKub();
			}
		}
		
		/**
		 * Called when the form is submitted.
		 */
		private function submitFormHandler(event:FormComponentEvent):void {
			_form.disable();
			FrontControlerKB.getInstance().submit(_form.name, onPostComplete);
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