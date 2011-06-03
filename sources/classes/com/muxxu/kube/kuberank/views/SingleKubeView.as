package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.BackWindow;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kuberank.components.CubeButtonIcon;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.components.form.KubeDetailsForm;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.date.DateUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Displays the details about a kube and provides buttons to vote for.
	 * 
	 * @author Francois
	 */
	public class SingleKubeView extends AbstractView {
		
		[Embed(source="../../../../../../../assets/close.kub", mimeType="application/octet-stream")]
		private var _closeKub:Class;
		
		private var _data:CubeData;
		private var _cube:CubeResult;
		private var _background:BackWindow;
		private var _opened:Boolean;
		private var _details:CssTextField;
		private var _form:KubeDetailsForm;
		private var _infoTxt:CssTextField;
		private var _closeBt:CubeButtonIcon;
		private var _deleteBt:ButtonKube;
		private var _viewKubesBt:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SingleKubeView</code>.
		 */
		public function SingleKubeView() {
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
			var model:ModelKR = event.model as ModelKR;
			_data = model.openedCube;
			if(_data != null) {
				_form.populate(_data, model.votesDone, model.votesTotal);
				populate();
				TweenLite.to(this, .25, {autoAlpha:1, onComplete:onAppearComplete});
				_deleteBt.visible = _data.uid == Config.getNumVariable("uid");
				_viewKubesBt.visible = !_deleteBt.visible;
			}else{
				_opened = false;
				TweenLite.to(this, .25, {autoAlpha:0});
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			alpha = 0;
			visible = false;
			
			_background = addChild(new BackWindow()) as BackWindow;
			_details = addChild(new CssTextField("kubeDetails")) as CssTextField;
			_form = addChild(new KubeDetailsForm()) as KubeDetailsForm;
			_infoTxt = addChild(new CssTextField("voteInfo")) as CssTextField;
			_closeBt = addChild(new CubeButtonIcon(new _closeKub())) as CubeButtonIcon;
			_cube = addChild(new CubeResult()) as CubeResult;
			_deleteBt = addChild(new ButtonKube(Label.getLabel("deleteKube"), false, null, true)) as ButtonKube;
			_viewKubesBt = addChild(new ButtonKube(Label.getLabel("viewUserKubes"), false)) as ButtonKube;
			
			_infoTxt.text = Label.getLabel("voteInformations");
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			computePositions();
		}
		
		/**
		 * Called when the user clicks somewhere
		 */
		private function clickHandler(event:MouseEvent):void {
			if(_opened && !contains(event.target as DisplayObject) || event.target == _closeBt) {
				FrontControlerKR.getInstance().closeKube();
			}else if(event.target == _deleteBt) {
				FrontControlerKR.getInstance().deleteKube(_data);
			}else if(event.target == _viewKubesBt) {
				FrontControlerKR.getInstance().searchKubesOfUser(_data.userName);
			}
		}
		
		/**
		 * Flags the content as opened when its opening transition completes.
		 */
		private function onAppearComplete():void { _opened = true; }

		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			_background.width = 700;
			_background.height = 300;
			
			_details.x = _cube.x + _cube.width;
			_details.y = 15;
			
			_form.x = _details.x;
			_form.y = Math.round(_details.y + _details.height + 25);
			
			_infoTxt.x = _form.x;
			_infoTxt.width = Math.round(_background.width - _infoTxt.x - 5);
			_infoTxt.y = Math.round(_background.height - _infoTxt.height - 10);
			
			_closeBt.y = 6;
			_closeBt.x = Math.round(_background.width - _closeBt.width - 6);
			
			_deleteBt.x = Math.round(150 - _deleteBt.width * .5);
			_deleteBt.y = Math.round(_background.height - _deleteBt.height - 10);
			
			_viewKubesBt.x = Math.round(150 - _viewKubesBt.width * .5);
			_viewKubesBt.y = Math.round(_background.height - _viewKubesBt.height - 10);
			
			x = Math.round((stage.stageWidth - _background.width) * .5);
			y = Math.round((stage.stageHeight - _background.height) * .5);
		}
		
		/**
		 * Populates the component
		 */
		private function populate():void {
			var endPos:Point = new Point(150, _background.height * .4);
			_cube.populate(_data, endPos.clone(), endPos, 150);
			_cube.doOpeningTransition(0, true);
			
			var details:String;

			var date:Date = new Date(_data.date * 1000);
			if(new Date().getDay() == date.getDay() && new Date().getTime() - date.getTime() < 24 * 60 * 60 * 1000) {
				details = Label.getLabel("kubeDetailsLongToday");
				details = details.replace(/\{DATE\}/gi, DateUtils.format(date, "_h_:_i_"));
			}else{
				details = Label.getLabel("kubeDetailsLong");
				details = details.replace(/\{DATE\}/gi, DateUtils.format(date, "_w_/_m_/_Y_"));
			}
			details = details.replace(/\{KUBE_NAME\}/gi, _data.name);
			details = details.replace(/\{USER_ID\}/gi, _data.uid);
			details = details.replace(/\{USER_NAME\}/gi, _data.userName);
			_details.text = details;
			
			computePositions();
		}
		
	}
}