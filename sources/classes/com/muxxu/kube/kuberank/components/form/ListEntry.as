package com.muxxu.kube.kuberank.components.form {
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.button.TextAlign;
	import gs.TweenLite;

	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kubebuilder.graphics.DeleteIconGraphic;
	import com.muxxu.kube.kubebuilder.graphics.ShareIconGraphic;
	import com.muxxu.kube.kubebuilder.graphics.ViewListIconGraphic;
	import com.muxxu.kube.kuberank.vo.ListData;
	import com.nurun.components.button.IconAlign;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author Francois
	 * @date 5 juin 2011;
	 */
	public class ListEntry extends Sprite {
		private var _deleteBt:ButtonKube;
		private var _shareBt:ButtonKube;
		private var _viewBt:ButtonKube;
		private var _label:CssTextField;
		private var _shareBtHolder:Sprite;
		private var _copyUrl:ButtonKube;
		private var _copyBbc:ButtonKube;
		private var _mask:Shape;
		private var _myKubesEntry:Boolean;
		private var _data:ListData;
		private var _nameChanged:Boolean;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListEntry</code>.
		 */
		public function ListEntry(myKubesEntry:Boolean = false) {
			_myKubesEntry = myKubesEntry;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Populates the component
		 */
		public function populate(data:ListData):void {
			_data = data;
			if(_myKubesEntry) {
				_label.text = _data.name;
			}else{
				_label.text = Label.getLabel("listEntry").replace(/\{NBR_KUBES\}/gi, data.kubes.length).replace(/\{NAME\}/gi, _data.name);
			}
			_deleteBt.enabled = !_myKubesEntry;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_deleteBt = addChild(new ButtonKube("", false, new DeleteIconGraphic())) as ButtonKube;
			_viewBt = addChild(new ButtonKube("", false, new ViewListIconGraphic())) as ButtonKube;
			_label = addChild(new CssTextField("listsEntry")) as CssTextField;
			_shareBtHolder = addChild(new Sprite()) as Sprite;
			_shareBt = addChild(new ButtonKube("", false, new ShareIconGraphic())) as ButtonKube;
			_copyUrl = _shareBtHolder.addChild(new ButtonKube(Label.getLabel("listEntryShareURL"))) as ButtonKube;
			_copyBbc = _shareBtHolder.addChild(new ButtonKube(Label.getLabel("listEntryShareBBC"))) as ButtonKube;
			_mask = addChild(new Shape()) as Shape;
			
			_copyUrl.textAlign = _copyBbc.textAlign = TextAlign.LEFT;
			
			_copyBbc.height = _copyUrl.height = _copyBbc.y = 20;
			_copyUrl.height ++;
			_viewBt.height = _shareBt.height = _deleteBt.height = 
			_viewBt.width = _shareBt.width = _deleteBt.width = 40;
			_viewBt.iconAlign = _shareBt.iconAlign = _deleteBt.iconAlign = IconAlign.CENTER;
			
			_copyBbc.width = _copyUrl.width = Math.max(_copyBbc.width, _copyUrl.width) + 2;
			
			_mask.graphics.beginFill(0xff0000, 0);
			_mask.graphics.drawRect(0, 0, _copyBbc.width, 40);
			_mask.graphics.endFill();
			_shareBtHolder.mask = _mask;
			_mask.scaleX = 0;
			
			PosUtils.hPlaceNext(10, _deleteBt, _shareBt, _viewBt, _label);
			
			_shareBtHolder.x = _mask.x = Math.round(_shareBt.x + _shareBt.width) - 1;
			_label.y = 2;
			_label.width = 837 - _label.x;
			_label.height = 36;
			_label.maxChars = 25;
			_label.multiline = false;
			_label.wordWrap = false;
			_label.autoSize = TextFieldAutoSize.NONE;
			
			graphics.lineStyle(0, 0x265367, 1);
			graphics.beginFill(0xffffff, .1);
			graphics.drawRect(_label.x, 0, _label.width, 39);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_label.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_label.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when a component is clicked
		 */
		private function clickHandler(event:MouseEvent):void {
			var url:String = _myKubesEntry? Config.getPath("shareProfilePath") : Config.getPath("shareListPath");
			url = url.replace(/\{USER\}/gi, Config.getVariable("uname"));
			url = url.replace(/\{LID\}/gi, _data.id);
			
			if(event.target == _deleteBt) {
				FrontControlerKR.getInstance().deleteList(_data.id);
				
			}else if(event.target == _viewBt) {
				if(_myKubesEntry) {
					FrontControlerKR.getInstance().searchKubesOfUser(Config.getVariable("uname"));
				}else{
					FrontControlerKR.getInstance().openList(_data.id);
				}
				
			}else if(event.target == _copyBbc) {
				var link:String = _myKubesEntry? Label.getLabel("listEntryCopyBBCProfile") : Label.getLabel("listEntryCopyBBC");
				link = link.replace(/\{URL\}/gi, url);
				link = link.replace(/\{NAME\}/gi, _data.name);
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, link);
				
			}else if(event.target == _copyUrl) {
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, url);
			
			}else if(event.target == _label && !_myKubesEntry) {
				_nameChanged = false;
				_label.type = TextFieldType.INPUT;
				_label.border = true;
				_label.background = true;
				_label.text = _data.name;
				_label.setSelection(0, _label.length);
				stage.focus = _label;
			}
			
			if(event.target == _copyBbc || event.target == _copyUrl) {
				TweenLite.from(_shareBt, .75, {colorMatrixFilter:{brightness:2.5, remove:true}});
				TweenLite.to(_mask, .2, {scaleX:0});
			}
		}
		
		/**
		 * Called when a component is rolled over.
		 */
		private function mouseOverHandler(event:MouseEvent):void {
			if(event.target == _shareBt || _shareBtHolder.contains(event.target as DisplayObject)) {
				TweenLite.to(_mask, .2, {scaleX:1});
			}
		}
		
		/**
		 * Called when a component is rolled out.
		 */
		private function mouseOutHandler(event:MouseEvent):void {
			if(event.target == _shareBt || _shareBtHolder.contains(event.target as DisplayObject)) {
				TweenLite.to(_mask, .2, {scaleX:0});
			}
		}
		
		
		
		
		//__________________________________________________________ FOCUS EVENT
		
		/**
		 * Called when textfield looses the focus
		 */
		private function focusOutHandler(event:FocusEvent):void {
			submitNameChange();
		}
		
		
		
		//__________________________________________________________ KEYBOARD EVENT
		
		/**
		 * Called when a key is released
		 */
		private function keyUpHandler(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.ENTER) {
				submitNameChange();
			}else if(event.keyCode == Keyboard.ESCAPE) {
				_nameChanged = false;
				submitNameChange();
			}else{
				_nameChanged = true;
			}
		}
		
		/**
		 * Submits the label change
		 */
		private function submitNameChange():void {
			//Due to a non localized bug (probably on the CSSTextfield), i have
			//to reset the text to the value it had before type change.
			//When _label.type is modified, it resets the text to the value it
			//was before edit :(...
			var text:String = _label.text;
			_label.type = TextFieldType.DYNAMIC;
			populate(_data);
			_label.border = false;
			_label.background = false;
			if(_nameChanged) {
				FrontControlerKR.getInstance().renameList(_data, text);
			}
			stage.focus = null;
		}
		
	}
}