package com.muxxu.kube.hof.views {
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
		
		[Embed(source="../../../../../../../assets/podium.png")]
		private var _podiumClass:Class;
		
		private var _earth:Bitmap;
		private var _earthHolder:Sprite;
		private var _pressed:Boolean;
		private var _offsetDrag:Point;
		private var _offsetRotation:Number;
		private var _posHistory:Array;
		private var _velocity:Number;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>EarthView</code>.
		 */
		public function EarthView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			var model:ModelHOF = event.model as ModelHOF;
			model;
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
			_velocity = 0;
			
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
			
			m = new Matrix();
			m.rotate(Math.PI/2);
			m.translate(_earth.width, (_earth.width-bmpPodium.width) * .5);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			
			m = new Matrix();
			m.rotate(-Math.PI/2);
			m.translate(0, (_earth.width+bmpPodium.width) * .5);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			
			m = new Matrix();
			m.rotate(Math.PI);
			m.translate((_earth.width+bmpPodium.width) * .5, _earth.height);
			_earth.bitmapData.draw(bmpPodium, m, null, null, null, true);
			
			grassSrc.unlock();
			
			_earth.smoothing = true;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			if(_pressed) {
				_earthHolder.rotation = _offsetRotation + (mouseX - _offsetDrag.x) * .05;
				_posHistory.push(mouseX);
				if(_posHistory.length > 5) _posHistory.shift();
			}else if(Math.abs(_velocity) > .1){
				_velocity *= .9;
				_earthHolder.rotation += _velocity;
			}
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			computePositions();
		}

		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_offsetDrag = new Point(mouseX, mouseY);
			_offsetRotation = _earthHolder.rotation;
			_posHistory = [];
		}

		private function mouseUpHandler(event:MouseEvent):void {
			_pressed = false;
			var i:int, len:int, avg:Number;
			len = _posHistory.length;
			avg = 0;
			for(i = 1; i < len; ++i) {
				avg += _posHistory[i] - _posHistory[i-1];
			}
			avg /= len;
			_velocity = avg * .05;
		}
				
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions(event:Event = null):void {
			_earth.x = - _earth.width*.5;
			_earth.y = - _earth.height*.5;
			_earthHolder.x = Math.round(stage.stageWidth * .5);
			_earthHolder.y = 1200;
		}
		
	}
}