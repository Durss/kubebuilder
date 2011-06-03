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

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
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
		private var _sharePath:CssTextField;
		private var _copyBt:ButtonKube;
		private var _shareTitle:CssTextField;
		
		
		
		
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
			_sharePath.text = Config.getPath("sharePath").replace(/\{KID\}/gi, _data.id);
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
			_shareTitle = addChild(new CssTextField("kubeDetails")) as CssTextField;
			_sharePath = addChild(new CssTextField("sharePath", false)) as CssTextField;
			_copyBt = addChild(new ButtonKube(Label.getLabel("copySharePath"))) as ButtonKube;
			
			_tooltipMessages = new Dictionary();
			_tooltipMessages[_voteBt] = Label.getLabel("voteTooltip");
			_tooltipMessages[_alertBt] = Label.getLabel("warnTooltip");
			
			_tooltip.mouseEnabled = false;
			_tooltip.mouseChildren = false;
			
			_sharePath.selectable = true;
			_sharePath.multiline = false;
			_sharePath.wordWrap = false;
			_sharePath.autoSize = TextFieldAutoSize.NONE;
			_sharePath.border = true;
			_sharePath.borderColor = 265367;
			_sharePath.background = true;
			_sharePath.backgroundColor = 0xffffff;
			
			_shareTitle.wordWrap = false;
			_shareTitle.background = true;
			_shareTitle.backgroundColor = 0x265367;
			
			_shareTitle.text = Label.getLabel("shareTitle");
			
			computePositions();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			_sharePath.addEventListener(FocusEvent.FOCUS_IN, focusInShareHandler);
		}
		
		/**
		 * Called When the share label receives the focus
		 */
		private function focusInShareHandler(event:FocusEvent):void {
			stage.focus = _sharePath;
			setTimeout(_sharePath.setSelection, 0, 0, _sharePath.length);//Fuckin' hack to get selection working on focus >_<
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_voteBt.width = _alertBt.width = Math.max(_voteBt.width, _alertBt.width);
			_alertBt.y = Math.round(_voteBt.height + 5);
			_shareTitle.y = Math.round(_alertBt.y + _alertBt.height + 10);
			_sharePath.y = Math.round(_shareTitle.y + _shareTitle.height);
			_sharePath.width = 300;
			_shareTitle.width = 301;
			_sharePath.height = _copyBt.height - 1;
			_copyBt.x = _sharePath.width;
			_copyBt.y = _sharePath.y;
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
			}else if(event.target == _copyBt) {
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _sharePath.text);
			}
		}
		
	}
}