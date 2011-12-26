package com.muxxu.kube.hof.views {
	import com.muxxu.kube.hof.components.CloudsView;
	import com.muxxu.kube.hof.vo.HOFDataCollection;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.hof.components.MonthResult;
	import com.muxxu.kube.hof.model.ModelHOF;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.math.MathUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author Francois
	 * @date 26 juin 2011;
	 */
	public class EarthView extends AbstractView {
		
		[Embed(source="../../../../../../../assets/backHOF.jpg")]
		private var _backgroundClass:Class;
		
		[Embed(source="../../../../../../../assets/grass.png")]
		private var _grassClass:Class;
		
		[Embed(source="../../../../../../../assets/podiumHOF.png")]
		private var _podiumClass:Class;
		
		private var _earth:Bitmap;
		private var _earthHolder:Sprite;
		private var _pressed:Boolean;
		private var _offsetDrag:Point;
		private var _offsetRotation:Number;
		private var _posHistory:Array;
		private var _result1:MonthResult;
		private var _result4:MonthResult;
		private var _result2:MonthResult;
		private var _result3:MonthResult;
		private var _initialized:Boolean;
		private var _endR:Number;
		private var _virtualRotation:Number;
		private var _rotationMax:Number;
		private var _data:HOFDataCollection;
		private var _indexOffset:Number;
		private var _length:uint;
		private var _resultItems:Vector.<MonthResult>;
		private var _clouds:CloudsView;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>EarthView</code>.
		 */
		public function EarthView() {
			
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			var model:ModelHOF = event.model as ModelHOF;
			_data = model.hofData;
			if(!_initialized) {
				_initialized = true;
				initialize();
				
				_length = model.hofData.length;
				_rotationMax = 90 * _length-90;
				_indexOffset = _length % 4;
				_endR = _virtualRotation = _rotationMax;
			}
		}



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
			_earthHolder = addChild(new Sprite()) as Sprite;
			_earth = _earthHolder.addChild(new _backgroundClass()) as Bitmap;
			_clouds = _earthHolder.addChild(new CloudsView(_earth.width * .57 - 0, _earth.width * .65)) as CloudsView;
			_endR = 0;
			_virtualRotation = 0;
			
			//Generate grass
			var grassBmp:Bitmap = new _grassClass();
			var i:int, len:int, radius:int, rect:Rectangle, point:Point, offset:Number;
			var blur:Number, center:Number, grassBmd:BitmapData, grassSrc:BitmapData, inc:Number, totWeeds:int;
			len = 2100*1.2;
			inc = .003/1.2;
			grassBmd = new BitmapData(16, 19, true, 0);
			grassBmd.lock();
			grassSrc = grassBmp.bitmapData;
			grassSrc.lock();
			totWeeds = Math.round(grassSrc.width / 16) - 1;
			center = _earth.width * .5;
			radius = 1808 * .5 - 230;
			offset = -MathUtils.DEG2RAD * 90;
			for(i = 0; i < len; ++i) {
				rect = new Rectangle(16*MathUtils.randomNumberFromRange(0, totWeeds)*1, 0, 16, 19);
				point = new Point();
				point.x = Math.cos(i*inc + offset) * (radius + Math.random()*230) + center + (Math.random() - Math.random() * 20);
				point.y = Math.sin(i*inc + offset) * (radius + Math.random()*230) + center + (Math.random() - Math.random() * 20);
				blur = ((Math.sqrt(Math.pow(point.x-center,2) + Math.pow(point.y-center,2)) - 674) / 230) * 4 + .5;
				grassBmd.copyPixels(grassSrc, rect, new Point(0,0));
				grassBmd.applyFilter(grassBmd, grassBmd.rect, new Point(0,0), new BlurFilter(blur, blur, 3));
				var m:Matrix = new Matrix();
				m.rotate(i*inc);
				m.scale(1-blur/8 + .3, 1-blur/8 + .3);
//				m.translate(point.x + Math.cos(i*inc + offset) * 16, point.y + Math.sin(i*inc + offset) * 19);
				m.translate(point.x, point.y);
				_earth.bitmapData.draw(grassBmd, m, null, null, null, true);
			}
			
			var bmpPodium:Bitmap = new _podiumClass();
			m = new Matrix();
			m.translate((_earth.width-bmpPodium.width) * .5, 0);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			_result1 = _earthHolder.addChild(new MonthResult()) as MonthResult;
			m.translate(-_earth.width * .5, -_earth.height * .5);
			_result1.transform.matrix = m;
			
			m = new Matrix();
			m.rotate(Math.PI/2);
			m.translate(_earth.width, (_earth.width-bmpPodium.width) * .5);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			_result2 = _earthHolder.addChild(new MonthResult()) as MonthResult;
			m.translate(-_earth.width * .5, -_earth.height * .5);
			_result2.transform.matrix = m;
			
			m = new Matrix();
			m.rotate(Math.PI);
			m.translate((_earth.width+bmpPodium.width) * .5, _earth.height);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			_result3 = _earthHolder.addChild(new MonthResult()) as MonthResult;
			m.translate(-_earth.width * .5, -_earth.height * .5);
			_result3.transform.matrix = m;
			
			m = new Matrix();
			m.rotate(-Math.PI/2);
			m.translate(0, (_earth.width+bmpPodium.width) * .5);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			_result4 = _earthHolder.addChild(new MonthResult()) as MonthResult;
			m.translate(-_earth.width * .5, -_earth.height * .5);
			_result4.transform.matrix = m;
			
//			_earthHolder.scaleX = _earthHolder.scaleY = .25;//TODO remove
			grassSrc.unlock();
			
			_earth.smoothing = true;
			
			_resultItems = new Vector.<MonthResult>();
			_resultItems.push(_result1);
			_resultItems.push(_result2);
			_resultItems.push(_result3);
			_resultItems.push(_result4);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			computePositions();
		}
				
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions(event:Event = null):void {
			_earth.x = - _earth.width*.5;
			_earth.y = - _earth.height*.5;
			_earthHolder.x = Math.round(stage.stageWidth * .5);
			_earthHolder.y = 1200*_earthHolder.scaleY;
		}
		
		/**
		 * Called on ENTER_FRAME event to rotate the earth
		 */
		private function enterFrameHandler(event:Event):void {
			if(_pressed) {
				_endR = _offsetRotation + (mouseX - _offsetDrag.x) * .3;
				_posHistory.push(mouseX);
				if(_posHistory.length > 3) _posHistory.shift();
			}
			
			_endR = MathUtils.restrict(_endR, 0, _rotationMax);
			
			_virtualRotation += (_endR - _virtualRotation) * .1;
			
			_earthHolder.rotation = _virtualRotation;
			
			var i:int, len:int, index:int;
			len = _resultItems.length;
			for(i = 0; i < len; ++i) {
				var r:Number = _resultItems[i].rotation;
				if (r == -90) r = 270;
				index = Math.round((_virtualRotation + r) / 360)*4-i;
				if(index < 0) index = _length + index;
				_resultItems[i].populate(_data.getHOFDataAtIndex(index%_length));
			}
		}
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS

		private function mouseDownHandler(event:MouseEvent):void {
			if(event.target is CubeResult) return;
			
			_pressed = true;
			_offsetDrag = new Point(mouseX, mouseY);
			_offsetRotation = _virtualRotation;
			_posHistory = [];
		}

		private function mouseUpHandler(event:MouseEvent):void {
			if(!_pressed) return;
			
			_pressed = false;
			var i:int, len:int, avg:Number;
			len = _posHistory.length;
			avg = 0;
			for(i = 1; i < len; ++i) {
				avg += _posHistory[i] - _posHistory[i-1];
			}
			avg /= len;
			_endR += avg * .5;
			_endR = Math.round(_endR/90)*90;
		}
	}
}