package com.muxxu.kube.kuberank.components.form {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kubebuilder.graphics.DeleteIconGraphic;
	import com.muxxu.kube.kubebuilder.graphics.ShareIconGraphic;
	import com.muxxu.kube.kubebuilder.graphics.ViewListIconGraphic;
	import com.muxxu.kube.kuberank.vo.ListData;
	import com.nurun.components.button.IconAlign;
	import com.nurun.components.text.CssTextField;
	import com.nurun.utils.pos.PosUtils;

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
		public function ListEntry(data:ListData, myKubesEntry:Boolean = false) {
			_data = data;
			_myKubesEntry = myKubesEntry;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



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
			_deleteBt = addChild(new ButtonKube("", false, new DeleteIconGraphic())) as ButtonKube;
			_viewBt = addChild(new ButtonKube("", false, new ViewListIconGraphic())) as ButtonKube;
			_label = addChild(new CssTextField("listsEntry")) as CssTextField;
			_shareBtHolder = addChild(new Sprite()) as Sprite;
			_shareBt = addChild(new ButtonKube("", false, new ShareIconGraphic())) as ButtonKube;
			_copyUrl = _shareBtHolder.addChild(new ButtonKube("Copier URL [!!!]")) as ButtonKube;//TODO
			_copyBbc = _shareBtHolder.addChild(new ButtonKube("Copier BBCode [!!!]")) as ButtonKube;//TODO
			_mask = addChild(new Shape()) as Shape;
			
			_label.text = _data.name;
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
			if(event.target == _deleteBt) {
				
			}else if(event.target == _viewBt) {
				
			}else if(event.target == _copyBbc) {
				
			}else if(event.target == _copyUrl) {
				
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