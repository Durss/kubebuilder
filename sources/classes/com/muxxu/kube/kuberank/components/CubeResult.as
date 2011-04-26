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
	import com.muxxu.kube.kubebuilder.graphics.WingGraphic;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.volume.Cube;
	import com.nurun.core.lang.Disposable;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * Creates a result cube
	 * 
	 * @author Francois
	 */
	public class CubeResult extends Sprite {
		
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
		override public function get width():Number { return _size; }
		
		/**
		 * Gets the height of the component.
		 */
		override public function get height():Number { return _size; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Populates the component.
		 * 
		 * @param data		data to display
		 * @param startPos	position to start the transition from
		 * @param endPos	position to end the transition to
		 * @param size		size of th cube
		 */
		public function populate(data:CubeData, startPos:Point, endPos:Point, size:int = 70):void {
			TweenLite.killTweensOf(_cube);
			TweenLite.killTweensOf(_holder);
			TweenLite.killTweensOf(_shadow);
			TweenLite.killTweensOf(_wingLeft);
			TweenLite.killTweensOf(_wingRight);
			TweenLite.killDelayedCallsTo(onOpeningTransitionComplete);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			_size = size;
			_data = data;
			_endPos = endPos;
			_startPos = startPos;
			
			_cube.leftFace = new CubeFace(_data.kub.faceSides);
			_cube.rightFace = new CubeFace(_data.kub.faceSides);
			_cube.frontFace = new CubeFace(_data.kub.faceSides);
			_cube.backFace = new CubeFace(_data.kub.faceSides);
			_cube.topFace = new CubeFace(_data.kub.faceTop); 
			_cube.bottomFace = new CubeFace(_data.kub.faceBottom);
			
			_cube.width = _cube.height = _cube.depth = _size;
			_wingLeft.scaleX = _wingLeft.scaleY = _wingRight.scaleX = _wingRight.scaleY = .3 + (_size/70 - 1)*.6;
			_shadow.scaleX = _shadow.scaleY = _size/70;
			_shadow.y = _size * .5;
			_shadow.x = -_shadow.width * .5;
			_shadow.alpha = 0;
			_wingRight.scaleX = -_wingRight.scaleX;
			_wingLeft.x = -_cube.width * .5;
			_wingRight.x = _cube.width * .5;
			
			_endRZ = 13;
			_endRY = 43;
			_cube.rotationX = _cube.rotationY = _cube.rotationZ = 0;
			_cube.x = _cube.y = 0;
			
			x = _endPos.x;
			y = _endPos.y;
			_holder.x = _startPos.x - _endPos.x;
			_holder.y = _startPos.y - _endPos.y;
		}
		
		/**
		 * Does the opening transition.
		 */
		public function doOpenTransition(lastDisplayDelay:int = 0):void {
			var delayBase:Number = lastDisplayDelay + .5;
			_wingLeft.rotation = 50;
			_wingRight.rotation = -50;
			_wingLeft.filters = _wingRight.filters = [new BlurFilter(0,8,2)];
			_holder.filters = [];
			
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
		public function dispose():void {
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
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_cube.transform.perspectiveProjection = pp;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		/**
		 * Called when an item is rolled over.
		 */
		private function rollOverHandler(event:MouseEvent):void {
			//TODO
		}

		/**
		 * Called when an item is rolled out.
		 */
		private function rollOutHandler(event:MouseEvent):void {
			//TODO
		}
		
		/**
		 * Called when mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_rotationOffsets = new Point(_cube.rotationZ, _cube.rotationY);
			_mouseOffset = new Point(mouseX, mouseY);
		}

		/**
		 * Called when mouse is released.
		 */
		private function mouseUpHandler(event:MouseEvent):void {
			_pressed = false;
		}
		
		/**
		 * Called on ENTER_FRAME event.
		 */
		private function enterFrameHandler(event:Event):void {
			if(_pressed) {
				_endRZ = _rotationOffsets.x - (_mouseOffset.y - mouseY);
				_endRY = _rotationOffsets.y + (_mouseOffset.x - mouseX);
			}
			_cube.rotationZ += (_endRZ - _cube.rotationZ) * .1;
			_cube.rotationY += (_endRY - _cube.rotationY) * .1;
			_cube.validate();
		}
		
		/**
		 * Called when wings are hidden
		 */
		private function onOpeningTransitionComplete():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_cube.rotationZ = _cube.rotationZ % 360;
			_cube.rotationY = _cube.rotationY % 360;
		}
		
	}
}