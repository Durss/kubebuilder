package com.muxxu.kube.hof.components {
	import com.muxxu.kube.hof.vo.HOFData;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.text.CssTextField;
	import com.nurun.utils.string.StringUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 déc. 2011;
	 */
	public class MonthResult extends Sprite {
		
		private var _cubes:Vector.<CubeResult>;
		private var _labels:Vector.<Bitmap>;
		private var _data:HOFData;
		private var _tfPseudo:CssTextField;
		private var _tfDate:CssTextField;
		private var _bmpDate:Bitmap;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>MonthResult</code>.
		 */
		public function MonthResult() {
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
		public function populate(data:HOFData):void {
			if(data == _data) return;
			
			_data = data;
			
			var date:Date = data.date;
//			_tfDate.text = data.id.toString();
//			_tfDate.text = StringUtils.toDigit(date.getDate(),2)+"/"+StringUtils.toDigit(date.getMonth()+1,2)+"/"+StringUtils.toDigit(date.getFullYear(),4);
			_tfDate.text = StringUtils.toDigit(date.getMonth()+1,2)+"/"+StringUtils.toDigit(date.getFullYear(),4);
			
			_bmpDate.bitmapData = new BitmapData(_tfDate.width, _tfDate.height, true, 0);
			_bmpDate.bitmapData.draw(_tfDate);
			_bmpDate.smoothing = true;
			
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			var i:int, len:int, cube:CubeResult;
			len = 3;
			_cubes = new Vector.<CubeResult>(len, true);
			_labels = new Vector.<Bitmap>(len, true);
			_tfPseudo = new CssTextField("top3Pseudo");
			_tfPseudo.width = 130;
			_tfPseudo.filters = [new BevelFilter(1,320,0xffffff,.6,0,.6,1,1,2,3,"outer")];
			
			_tfDate = new CssTextField("hofDate");
			_tfDate.text = " 00/00/0000 ";
			_tfDate.filters = [new BevelFilter(1,320,0xffffff,.6,0,.6,1,1,2,3,"outer")];
			
			_bmpDate = new Bitmap();
			addChild(_bmpDate);
			
			for(i = 0; i < len; ++i) {
				_labels[i] = new Bitmap(new BitmapData(_tfPseudo.width, 300, true, 0), PixelSnapping.NEVER, true);
				addChild(_labels[i]);
				cube = addChild(new CubeResult()) as CubeResult;
				_cubes[i] = cube;
			}
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when acomponent is clicked
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target is CubeResult) {
				FrontControlerKR.getInstance().openKube(CubeResult(event.target).data);
			}
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			var i:int, len:int;
			var positions:Array = [new Point(270, -45), new Point(100, 0), new Point(430, 60)];
			var labelsPos:Array = [new Point(275, 70), new Point(90, 100), new Point(440, 140)];
			var sizes:Array = [77, 66, 55];
			len = _cubes.length;
			
			for(i = 0; i < len; ++i) {
				_cubes[i].populate(_data.getCubeDataAtIndex(i), positions[i], positions[i], sizes[i] + 20);
				_cubes[i].doOpeningTransition(0, true);
				
				_tfPseudo.text = _data.getCubeDataAtIndex(i).userName;
				_labels[i].bitmapData.fillRect(_labels[i].bitmapData.rect, 0);
				_labels[i].bitmapData.draw(_tfPseudo);
				_labels[i].x = Math.round(Point(labelsPos[i]).x - _labels[i].width * .5);
				_labels[i].y = Point(labelsPos[i]).y;
			}
			
			_bmpDate.x = Math.round((510 - _bmpDate.width) * .5);
			_bmpDate.y = 170;
		}
		
	}
}