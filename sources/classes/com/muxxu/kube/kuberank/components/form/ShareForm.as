package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	/**
	 * 
	 * @author Francois
	 * @date 5 juin 2011;
	 */
	public class ShareForm extends Sprite {
		
		private var _sharePath:CssTextField;
		private var _copyBt:ButtonKube;
		private var _shareTitle:CssTextField;
		private var _title:String;
		private var _imageBt:ButtonKube;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ShareForm</code>.
		 */
		public function ShareForm(title:String) {
			_title = title;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Updates the component's value.
		 */
		public function update(path:String):void {
			_sharePath.text = path;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_shareTitle = addChild(new CssTextField("kubeDetails")) as CssTextField;
			_sharePath = addChild(new CssTextField("sharePath", false)) as CssTextField;
			_copyBt = addChild(new ButtonKube(Label.getLabel("copySharePath"))) as ButtonKube;
			_imageBt = addChild(new ButtonKube(Label.getLabel("copyShareImage"))) as ButtonKube;
			
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
			
			_shareTitle.text = _title;
			
			computePositions();
			
			_sharePath.addEventListener(FocusEvent.FOCUS_IN, focusInShareHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called When the share label receives the focus
		 */
		private function focusInShareHandler(event:FocusEvent):void {
			stage.focus = _sharePath;
			setTimeout(_sharePath.setSelection, 0, 0, _sharePath.length);//Fuckin' hack to get selection working on focus >_<
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			_sharePath.y = Math.round(_shareTitle.y + _shareTitle.height);
			_sharePath.width = 300;
			_shareTitle.width = 301;
			_sharePath.height = _copyBt.height - 1;
			_copyBt.x = _sharePath.width;
			_copyBt.y = _sharePath.y;
			_imageBt.x = _copyBt.x;
			_imageBt.width = _copyBt.width = Math.max(_imageBt.width, _copyBt.width) + 10;
		}
		
		/**
		 * Called when a button is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _copyBt) {
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _sharePath.text);
			}else if(event.target == _imageBt) {
				FrontControlerKR.getInstance().downloadPreview();
			}
		}
		
	}
}