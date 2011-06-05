package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.common.components.tooltip.ToolTip;
	import com.muxxu.kube.common.components.tooltip.content.TTTextContent;
	import com.muxxu.kube.common.vo.ToolTipMessage;
	import com.muxxu.kube.kuberank.components.CubeButtonIcon;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Creates the form displayed on the details window of a kube.
	 * Provides buttons to vote/report/etc..
	 * 
	 * @author Francois
	 */
	public class KubeDetailsForm extends Sprite {
		
		[Embed(source="../../../../../../../../assets/like.kub", mimeType="application/octet-stream")]
		private var _likeKub:Class;
		[Embed(source="../../../../../../../../assets/alert.kub", mimeType="application/octet-stream")]
		private var _alertKub:Class;
		
		private var _data:CubeData;
		private var _voteBt:ButtonKube;
		private var _alertBt:ButtonKube;
		private var _tooltip:ToolTip;
		private var _ttMessage:ToolTipMessage;
		private var _tooltipMessages:Dictionary;
		private var _votesDone:int;
		private var _votesTotal:int;
		private var _votedTxt:CssTextField;
		private var _shareKube:ShareForm;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeDetailsForm</code>.
		 */
		public function KubeDetailsForm() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Sets the current cube's data.
		 */
		public function populate(data:CubeData, votesDone:int, votesTotal:int):void {
			if(data == _data) {
				_votedTxt.text = Label.getLabel("confirmVote");
			}else{
				_votedTxt.text = Label.getLabel("voted");
			}
			_votesDone = votesDone;
			_votesTotal = votesTotal;
			_data = data;
			_voteBt.enabled = !_data.voted;
			_voteBt.alpha = _data.voted? .25 : 1;
			_votedTxt.visible = _data.voted;
			_shareKube.update(Config.getPath("sharePath").replace(/\{KID\}/gi, _data.id));
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_voteBt = addChild(new ButtonKube(Label.getLabel("vote"), true, new CubeButtonIcon(new _likeKub()))) as ButtonKube;
			_alertBt = addChild(new ButtonKube(Label.getLabel("warn"), true, new CubeButtonIcon(new _alertKub()), true)) as ButtonKube;
			_votedTxt = addChild(new CssTextField("votedText")) as CssTextField;
			_tooltip = addChild(new ToolTip()) as ToolTip;
			_ttMessage = new ToolTipMessage(new TTTextContent(), null);
			_shareKube = addChild(new ShareForm(Label.getLabel("shareTitle"))) as ShareForm;
//			_shareUser = addChild(new ShareForm(Label.getLabel("shareTitle"))) as ShareForm;
			
			_tooltipMessages = new Dictionary();
			_tooltipMessages[_voteBt] = Label.getLabel("voteTooltip");
			_tooltipMessages[_alertBt] = Label.getLabel("warnTooltip");
			
			_tooltip.mouseEnabled = false;
			_tooltip.mouseChildren = false;
			
			computePositions();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_voteBt.width = _alertBt.width = Math.max(_voteBt.width, _alertBt.width);
			_alertBt.y = Math.round(_voteBt.height + 5);
			_shareKube.y = Math.round(_alertBt.y + _alertBt.height + 10);
			PosUtils.centerIn(_votedTxt, _voteBt);
		}
		
		/**
		 * Called when a component is rolled over.
		 */
		private function mouseOverHandler(event:MouseEvent):void {
			if(_tooltipMessages[event.target] == null) return;
			
			var text:String = _tooltipMessages[event.target];
			text = text.replace(/\{VOTES\}/gi, (_votesTotal - _votesDone));
			text = text.replace(/\{TOTAL\}/gi, _votesTotal);
			
			_ttMessage.target = event.target as InteractiveObject;
			TTTextContent(_ttMessage.content).populate(text, "tooltipContent", DisplayObject(event.target).width - 9);
			_tooltip.open(_ttMessage);
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _voteBt) {
				FrontControlerKR.getInstance().vote(_data);
			}else if(event.target == _alertBt) {
				FrontControlerKR.getInstance().report(_data);
			}
		}
		
	}
}