package com.muxxu.kube.kuberank.components.form {
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
			_label.y = 2;
			
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
			
			graphics.lineStyle(0, 0x265367, 1);
			graphics.beginFill(0xffffff, .1);
			graphics.drawRect(_label.x, 0, 837 - _label.x, 39);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
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
				link = link.replace(/\{NAME\}/gi, Config.getVariable("uname"));
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, link);
				
			}else if(event.target == _copyUrl) {
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, url);
			}
			
			if(event.target == _copyBbc || event.target == _copyUrl) {
				TweenLite.from(_shareBt, .5, {colorMatrixFilter:{brightness:2, remove:true}});
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
		
	}
}