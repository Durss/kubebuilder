package com.muxxu.kube.kuberank.components {
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Back;
	import gs.easing.Bounce;
	import gs.easing.Elastic;
	import gs.easing.Linear;
	import gs.easing.Quad;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.kubebuilder.graphics.CubeShadowGraphic;
	import com.muxxu.kube.kubebuilder.graphics.StarGraphic;
	import com.muxxu.kube.kubebuilder.graphics.WingGraphic;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.button.AbstractNurunButton;
	import com.nurun.components.button.events.NurunButtonEvent;
	import com.nurun.components.volume.Cube;
	import com.nurun.core.lang.Disposable;
	import com.nurun.utils.math.MathUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * Creates a result cube
	 * 
	 * @author Francois
	 */
	public class CubeResult extends AbstractNurunButton {
		
		private var _startPos:Point;
		private var _endPos:Point;
		private var _cube:Cube;
		private var _data:CubeData;
		private var _wingLeft:WingGraphic;
		private var _wingRight:WingGraphic;
		private var _size:int;
		private var _endRZ:int;
		private var _endRY:int;
		private var _pressed:Boolean;
		private var _rotationOffsets:Point;
		private var _mouseOffset:Point;
		private var _shadow:CubeShadowGraphic;
		private var _holder:Sprite;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _endRX:Number;
		private var _starPool:Vector.<StarGraphic>;
		private var _starFalls:Boolean;
		private var _ready:Boolean;
		private var _starSpeeds:Dictionary;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeResult</code>.
		 */
		public function CubeResult() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the width of the component.
		 */
		override public function get width():Number { return _size * _scaleX; }
		
		/**
		 * Gets the height of the component.
		 */
		override public function get height():Number { return _size * _scaleY; }
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleX(value:Number):void {
			_scaleX = value;
			_cube.scaleX = value;
//			_cube.width = _cube.height = _cube.depth = _size * value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void {
			_scaleY = value;
			_cube.scaleY = value;
//			_cube.width = _cube.height = _cube.depth = _size * value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get scaleX():Number { return _scaleX; }
		
		/**
		 * @inheritDoc
		 */
		override public function get scaleY():Number { return _scaleY; }
		
		/**
		 * Gets the kube's data.
		 */
		public function get data():CubeData { return _data; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Stops all the animations
		 */
		public function stopAllAnimations():void {
			TweenLite.killTweensOf(_cube);
			TweenLite.killTweensOf(_holder);
			TweenLite.killTweensOf(_shadow);
			TweenLite.killTweensOf(_wingLeft);
			TweenLite.killTweensOf(_wingRight);
			TweenLite.killDelayedCallsTo(stopStarfall);
			TweenLite.killDelayedCallsTo(onOpeningTransitionComplete);
			
			_ready = false;
			_starFalls = false;
		}
		
		/**
		 * Populates the component.
		 * 
		 * @param data		data to display
		 * @param startPos	position to start the transition from
		 * @param endPos	position to end the transition to
		 * @param size		size of th cube
		 * @param wingFrame	frame of the wing (to select the color)
		 */
		public function populate(data:CubeData, startPos:Point, endPos:Point, size:int = 70, wingFrame:int = 1):void {
			stopAllAnimations();
			
			_size = size;
			_data = data;
			_endPos = endPos;
			_startPos = startPos;
			
			_cube.leftFace = new CubeFace(_data.kub.faceSides, true);
			_cube.rightFace = new CubeFace(_data.kub.faceSides);
			_cube.frontFace = new CubeFace(_data.kub.faceSides, true);
			_cube.backFace = new CubeFace(_data.kub.faceSides);
			_cube.topFace = new CubeFace(_data.kub.faceTop); 
			_cube.bottomFace = new CubeFace(_data.kub.faceBottom, true);
			
			_cube.width = _cube.height = _cube.depth = _size;
			_wingLeft.scaleX = _wingLeft.scaleY = _wingRight.scaleX = _wingRight.scaleY = .3 + (_size/70 - 1)*.6;
			_shadow.scaleX = _shadow.scaleY = _size/70;
			_shadow.y = _size * .5;
			_shadow.x = -_shadow.width * .5;
			_shadow.alpha = 0;
			_wingRight.scaleX = -_wingRight.scaleX;
			_wingLeft.x = -_cube.width * .5;
			_wingRight.x = _cube.width * .5;
			
			_wingLeft.gotoAndStop(wingFrame);
			_wingRight.gotoAndStop(wingFrame);
			
			_endRX = 20;
			_endRZ = 13;
			_endRY = 43;
			_cube.rotationX = _cube.rotationY = _cube.rotationZ = 0;
			_cube.x = _cube.y = 0;
			
			_scaleX = _scaleY = 1;
			
			x = _endPos.x;
			y = _endPos.y;
			_holder.x = _startPos.x - _endPos.x;
			_holder.y = _startPos.y - _endPos.y;
			
			_starSpeeds = new Dictionary();
			var i:int, len:int, star:StarGraphic;
			len = _starPool.length;
			for(i = 0; i < len; ++i) {
				star = _starPool[i];
				star.scaleX = star.scaleY = MathUtils.randomNumberFromRange(.3, 1);
				star.gotoAndStop(wingFrame);
				TweenLite.killTweensOf(star);
				star.alpha = Math.random();
				star.visible = true;
				_starSpeeds[star] = MathUtils.randomNumberFromRange(5, 20);
				star.y = _holder.y + MathUtils.randomNumberFromRange(-_size * .25, 100);
				star.x = MathUtils.randomNumberFromRange(_wingLeft.x - _wingLeft.width, _wingRight.x + _wingRight.width);
			}
		}
		
		/**
		 * Does the opening transition.
		 */
		public function doOpeningTransition(lastDisplayDelay:int = 0, simple:Boolean = false):void {
			var delayBase:Number = lastDisplayDelay + .5;
			_wingLeft.rotation = 50;
			_wingRight.rotation = -50;
			_wingLeft.filters = _wingRight.filters = [new BlurFilter(0,8,2)];
			_holder.filters = [];
			_cube.rotationX = 0;
			_cube.rotationY = 0;
			_cube.rotationZ = 0;
			
			_starFalls = !simple;
			if(_starFalls) {
				TweenLite.delayedCall(1, stopStarfall);
			}else{
				var i:int, len:int;
				len = _starPool.length;
				for(i = 0; i < len; ++i) {
					_starPool[i].visible = false;
				}
			}
			
			if(simple) {
				_wingRight.scaleX = _wingLeft.scaleX = 0;
				_wingLeft.filters = _wingRight.filters = [];
				_cube.rotationX = _endRX;
				_cube.rotationY = _endRY;
				_cube.rotationZ = _endRZ;
				_holder.y = 0;
				_shadow.alpha = 1;
				_cube.alpha = 1;
				TweenLite.from(_cube, .25, {autoAlpha:0});
//				TweenMax.to(_holder, 3, {y:-10, yoyo:0, ease:Sine.easeInOut});
//				TweenMax.to(_shadow, 3, {alpha:.65, yoyo:0, ease:Sine.easeInOut});
				onOpeningTransitionComplete();
				return;
			}
			
			if(Math.random() > .98) {
				//Atterissage en vrac
				TweenMax.to(_wingLeft, .055, {rotation:-30, yoyo:16, delay:delayBase});
				TweenMax.to(_wingRight, .055, {rotation:30, yoyo:16, delay:delayBase});
				TweenLite.to(_wingLeft, .3, {scaleX:0, delay:.5 + delayBase, blurFilter:{blurY:0, remove:true}, ease:Back.easeIn});
				TweenLite.to(_wingRight, .3, {scaleX:0, delay:.5 + delayBase, blurFilter:{blurY:0, remove:true}, ease:Back.easeIn});
				TweenLite.to(_holder, 1.2, {rotation:1800, ease:Bounce.easeOut, y:30, x:0, delay:delayBase});
				TweenLite.to(_shadow, 1.2, {ease:Bounce.easeOut, alpha:1, delay:delayBase});
				TweenLite.to(_cube, 1, {rotationY:1445, rotationX:1460, delay:delayBase, onUpdate:_cube.validate, ease:Linear.easeNone});
				TweenMax.to(_cube, .06, {rotationY:-30, startAt:{rotationY:30}, ease:Sine.easeInOut, yoyo:10, delay:1.5 + delayBase, onUpdate:_cube.validate});
				TweenMax.to(_cube, .1, {rotationY:0, ease:Sine.easeInOut, delay:2.2 + delayBase, onUpdate:_cube.validate});
				TweenLite.to(_cube, .2, {scaleY:.5, y:_cube.height*.25, delay:2.5 + delayBase});
				TweenLite.to(_cube, .5, {scaleY:1, ease:Back.easeOut, delay:2.7 + delayBase});
				TweenLite.to(_holder, .2, {y:-_size*1.1, ease:Sine.easeOut, delay:2.7 + delayBase});
				TweenLite.to(_holder, .5, {y:-20, ease:Sine.easeInOut, delay:2.9 + delayBase});
				TweenLite.delayedCall(3 + delayBase, onOpeningTransitionComplete);
				TweenMax.to(_holder, 3, {y:-10, yoyo:0, delay:3.6 + delayBase, ease:Sine.easeInOut});
				TweenMax.to(_shadow, 3, {alpha:.65, yoyo:0, delay:3.6 + delayBase, ease:Sine.easeInOut});
			}else if(Math.random() > .98) {
				//Atterissage eclaté au sol
				_wingLeft.scaleX = _wingRight.scaleX = 0;
				_cube.rotationX = 20;
				_cube.rotationY = 5;
				_holder.filters = [new BlurFilter(0,25,2)];
				TweenLite.to(_holder, .18, {ease:Sine.easeIn, y:_size*.8, x:0, dropShadowFilter:{blurY:0, index:0, remove:true}, delay:delayBase});
				TweenLite.to(_shadow, .18, {ease:Sine.easeIn, alpha:1, delay:delayBase});
				TweenLite.to(_cube, .08, {ease:Linear.easeNone, height:10, delay:delayBase+.12});
				TweenMax.to(_cube, .1, {rotationY:0, ease:Sine.easeInOut, delay:2.2 + delayBase, onUpdate:_cube.validate});
				TweenLite.to(_cube, .2, {scaleY:.5, y:_cube.height*.25, delay:2.5 + delayBase});
				TweenLite.to(_cube, .5, {scaleY:1, ease:Back.easeOut, delay:2.7 + delayBase});
				TweenLite.to(_holder, .2, {y:-_size*1.1, ease:Sine.easeOut, delay:2.7 + delayBase});
				TweenLite.to(_holder, .5, {y:-20, ease:Sine.easeInOut, delay:2.9 + delayBase});
				TweenLite.delayedCall(3 + delayBase, onOpeningTransitionComplete);
				TweenMax.to(_holder, 3, {y:-10, yoyo:0, delay:3.6 + delayBase, ease:Sine.easeInOut});
				TweenMax.to(_shadow, 3, {alpha:.65, yoyo:0, delay:3.6 + delayBase, ease:Sine.easeInOut});
				TweenLite.to(_cube, 1, {ease:Elastic.easeOut, height:_size, delay:2.73 + delayBase, easeParams:[3]});
			}else{
				//Atterissage normal
				TweenMax.to(_wingLeft, .055, {rotation:-30, yoyo:16});
				TweenMax.to(_wingRight, .055, {rotation:30, yoyo:16});
				TweenLite.to(_wingLeft, .3, {scaleX:0, delay:.7, blurFilter:{blurY:0, remove:true}, ease:Back.easeIn});
				TweenLite.to(_wingRight, .3, {scaleX:0, delay:.7, blurFilter:{blurY:0, remove:true}, ease:Back.easeIn});
				TweenLite.to(_cube, .3, {ease:Quad.easeOut, rotationX:-20, delay:.2, onUpdate:_cube.validate()});
				TweenLite.to(_cube, 1, {ease:Quad.easeOut, rotationX:20, delay:.8, onUpdate:_cube.validate()});
				TweenLite.to(_cube, .4, {ease:Quad.easeInOut, rotationZ:_endRZ, rotationY:_endRY, delay:1.8, onUpdate:_cube.validate(), onComplete:onOpeningTransitionComplete});
				TweenLite.to(_holder, 1, {ease:Quad.easeOut, y:0, x:0});
				TweenLite.to(_shadow, 1, {ease:Quad.easeOut, alpha:1});
				TweenMax.to(_holder, 3, {y:-10, yoyo:0, delay:3, ease:Sine.easeInOut});
				TweenMax.to(_shadow, 3, {alpha:.65, yoyo:0, delay:3, ease:Sine.easeInOut});
			}
		}
		
		/**
		 * Makes the component garbage collectable.
		 */
		override public function dispose():void {
			super.dispose();
			
			while(_holder.numChildren > 0) {
				if(_holder.getChildAt(0) is Disposable) Disposable(_holder.getChildAt(0)).dispose();
				_holder.removeChildAt(0);
			}
			
			while(numChildren > 0) {
				if(getChildAt(0) is Disposable) Disposable(getChildAt(0)).dispose();
				removeChildAt(0);
			}
			
			TweenLite.killTweensOf(_cube);
			TweenLite.killTweensOf(_holder);
			TweenLite.killTweensOf(_shadow);
			TweenLite.killTweensOf(_wingLeft);
			TweenLite.killTweensOf(_wingRight);
			TweenLite.killDelayedCallsTo(onOpeningTransitionComplete);
			
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_shadow = addChild(new CubeShadowGraphic()) as CubeShadowGraphic;
			_holder = addChild(new Sprite()) as Sprite;
			_wingLeft = _holder.addChild(new WingGraphic()) as WingGraphic;
			_wingRight = _holder.addChild(new WingGraphic()) as WingGraphic;
			_cube = _holder.addChild(new Cube()) as Cube;
			
			_starPool = new Vector.<StarGraphic>(50);
			var i:int, len:int, star:StarGraphic;
			len = _starPool.length;
			for(i = 0; i < len; ++i) {
				star = new StarGraphic();
				_starPool[i] = star;
				star.visible = false;
				addChildAt(star, 0);
			}
			
			mouseChildren = false;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			pp.fieldOfView = 40;
			_cube.transform.perspectiveProjection = pp;
		}
		
		/**
		 * Called when the stage is available.
		 */
		override protected function addedToStageHandler(event:Event):void {
			super.addedToStageHandler(event);
			addEventListener(NurunButtonEvent.OVER, customRollOverHandler);
			addEventListener(NurunButtonEvent.OUT, customRollOutHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Called when an item is rolled over.
		 */
		private function customRollOverHandler(event:NurunButtonEvent):void {
			TweenLite.to(this, .25, {scaleX:1.25, scaleY:1.25});
		}

		/**
		 * Called when an item is rolled out.
		 */
		private function customRollOutHandler(event:NurunButtonEvent = null):void {
			if(_pressed) return;
			TweenLite.to(this, .25, {scaleX:1, scaleY:1});
		}
		
		/**
		 * Called when mouse is pressed.
		 */
		override protected function mouseDownHandler(event:Event):void {
			super.mouseDownHandler(event);
			_pressed = true;
			_rotationOffsets = new Point(_cube.rotationX, _cube.rotationY);
			_mouseOffset = new Point(mouseX, mouseY);
		}

		/**
		 * Called when mouse is released.
		 */
		override protected function mouseUpHandler(event:Event):void {
			super.mouseUpHandler(event);
			_pressed = false;
			_endRZ = 13;
			_endRY = 43;
			_endRX = 20;
			if(stage != null && !_cube.hitTestPoint(stage.mouseX, stage.mouseY)) {
				customRollOutHandler();
			}
		}
		
		/**
		 * Called on ENTER_FRAME event.
		 */
		private function enterFrameHandler(event:Event):void {
			if(_ready) {
				if(_pressed) {
					_endRX = _rotationOffsets.x - (_mouseOffset.y - mouseY);
					_endRY = _rotationOffsets.y + (_mouseOffset.x - mouseX);
				}
				_cube.rotationX += (_endRX - _cube.rotationX) * .1;
				_cube.rotationY += (_endRY - _cube.rotationY) * .1;
				_cube.rotationZ += (_endRZ - _cube.rotationZ) * .1;
				_cube.validate();
			}else if(_starFalls) {
				var i:int, len:int, speed:Number, star:StarGraphic;
				len = _starPool.length;
				for(i = 0; i < len; ++i) {
					star = _starPool[i];
					speed = _starSpeeds[star];
					if(star.alpha <= 0 || (star.x == 0 && star.y == 0)) {
						star.alpha = 1;
						star.y = _holder.y + MathUtils.randomNumberFromRange(-_size * .25, _size * 1.5);
						star.x = MathUtils.randomNumberFromRange(_wingLeft.x - _wingLeft.width, _wingRight.x + _wingRight.width);
					}
					star.y += 10;
					star.alpha -= .1;
					star.rotation = Math.random() * 90;
				}
			}
		}
		
		/**
		 * Called when wings are hidden
		 */
		private function onOpeningTransitionComplete():void {
			_cube.rotationX = _cube.rotationX % 360;
			_cube.rotationY = _cube.rotationY % 360;
			_cube.rotationZ = _cube.rotationZ % 360;
			_ready = true;
		}
		
		/**
		 * Stops the star fall
		 */
		private function stopStarfall():void {
			_starFalls = false;
			var i:int, len:int;
			len = _starPool.length;
			for(i = 0; i < len; ++i) {
				TweenLite.to(_starPool[i], .25, {y:"+"+_starSpeeds[_starPool[i]]*5, autoAlpha:0});
			}
		}
		
	}
}