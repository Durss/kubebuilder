package com.muxxu.kube.exporter {

	import com.adobe.images.PNGEncoder;
	import com.muxxu.kube.common.utils.makeKubePreview;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.components.button.BaseButton;
	import com.nurun.components.scroll.scroller.scrollbar.Scrollbar;
	import com.nurun.components.text.CssTextField;
	import com.nurun.components.vo.Margin;
	import com.nurun.utils.draw.createRect;
	import com.nurun.utils.math.MathUtils;
	import com.nurun.utils.pos.PosUtils;
	import com.nurun.utils.pos.roundPos;
	import com.nurun.utils.text.CssManager;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois DURSUS for Nurun
	 * @date 12 juil. 2011;
	 */
	 
	[SWF(width="800", height="600", backgroundColor="0xFFFFFF", frameRate="31")]
	public class Exporter extends MovieClip {
		
		[Embed(source="../../assets/acier.kub", mimeType="application/octet-stream")]
		private var _kubClass:Class;
		private var _data:KUBData;
		private var _bitmap:Bitmap;
		private var _scroll:Scrollbar;
		private var _label:CssTextField;
		private var _exportPng:BaseButton;
		private var _importKub:BaseButton;
		private var _fr:FileReference;
		private var _lastName:String;
		private var _scaleInput:CssTextField;
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.
		 */
		public function Exporter() {
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
			CssManager.getInstance().setCss(".default { font-family:Arial; font-size:10; color:#000000; flash-bitmap:true; } ");
			_bitmap = addChild(new Bitmap()) as Bitmap;
			_data = new KUBData();
			_data.fromByteArray(new _kubClass());
			_scroll = addChild(new Scrollbar()) as Scrollbar;
			_label = addChild(new CssTextField("default")) as CssTextField;
			_exportPng = addChild(new BaseButton("Export .PNG", "default", createRect(0xffcccccc))) as BaseButton;
			_importKub = addChild(new BaseButton("Import .KUB", "default", createRect(0xffcccccc))) as BaseButton;
//			_scaleInput = addChild(new CssTextField("default")) as CssTextField;
			
//			_scaleInput.restrict = "[0-9]";
//			_scaleInput.type = TextFieldType.INPUT;
			_importKub.contentMargin = _exportPng.contentMargin = new Margin(10, 5, 10, 5);
			
			_scroll.height = 600;
			_scroll.rotation = -90;
			_scroll.percent = .5;
			_lastName = "kube.kub";
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when a component is clicked
		 */
		private function clickHandler(event:MouseEvent):void {
			if(!(event.target is BaseButton)) return;
			_fr = new FileReference();
			if(event.target == _importKub) {
				_fr.browse([new FileFilter(".KUB file", "*.kub")]);
				_fr.addEventListener(Event.SELECT, selectKubHandler);
				_fr.addEventListener(Event.COMPLETE, loadKubCompleteHandler);
			}else if(event.target == _exportPng) {
				_fr.save(PNGEncoder.encode(_bitmap.bitmapData), _lastName.replace(/\.kub/gi, ".png"));
			}
		}

		private function loadKubCompleteHandler(event:Event):void {
			_data = new KUBData();
			_data.fromByteArray(FileReference(event.target).data);
		}

		private function selectKubHandler(event:Event):void {
			FileReference(event.target).load();
			_lastName = _fr.name;
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
				
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions(event:Event = null):void {
			PosUtils.centerInStage(_bitmap);
			_scroll.y = stage.stageHeight - 30;
			_scroll.x = Math.round((stage.stageWidth - _scroll.height) * .5);
			PosUtils.hCenterIn(_label, stage);
			_label.y = _scroll.y - _label.height - _scroll.width;
			
			PosUtils.alignToBottomOf(_exportPng, stage, 5);
			PosUtils.alignToBottomOf(_importKub, stage, 5);
			_exportPng.x = stage.stageWidth * .5 + 5;
			_importKub.x = stage.stageWidth * .5 - 5 - _importKub.width;
			roundPos(_exportPng);
			roundPos(_importKub);
			roundPos(_bitmap);
			
			graphics.clear();
			graphics.lineStyle(0, 0xff0000, 1);
			graphics.drawRect(_bitmap.x - 1, _bitmap.y - 1, _bitmap.width + 1, _bitmap.height + 1);
			graphics.endFill();
		}

		private function enterFrameHandler(event:Event):void {
			var p:Number = MathUtils.interpolate(_scroll.percent, .01, 5);
			_bitmap.bitmapData = makeKubePreview(_data, false, p);
			_label.text = _bitmap.width+"x"+_bitmap.height+" :: scale="+(Math.round(p*1000)/1000);
			computePositions();
		}
		
	}
}