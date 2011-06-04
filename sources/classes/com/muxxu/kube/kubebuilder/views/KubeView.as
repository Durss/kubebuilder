package com.muxxu.kube.kubebuilder.views {
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Bounce;
	import gs.easing.Linear;
	import gs.easing.Sine;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.muxxu.kube.kubebuilder.graphics.CloudGraphic;
	import com.muxxu.kube.kubebuilder.graphics.WingGraphic;
	import com.muxxu.kube.kubebuilder.model.ModelKB;
	import com.nurun.components.volume.Cube;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.math.MathUtils;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;


	
	/**
	 * Displays the main kube
	 * 
	 * @author Francois
	 */
	public class KubeView extends AbstractView {
		
		private var _kube:Cube;
		private var _initialized:Boolean;
		private var _rotationOffsets:Point;
		private var _mouseOffset:Point;
		private var _pressed:Boolean;
		private var _endRX:Number;
		private var _endRY:Number;
		private var _wingLeft:WingGraphic;
		private var _wingRight:WingGraphic;
		private var _lastTopFace:BitmapData;
		private var _clouds:Vector.<CloudGraphic>;
		private var _speed:Number;
		private var _kubeHolder:Sprite;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeView</code>.
		 */
		public function KubeView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		override public function update(event:IModelEvent):void {
			var model:ModelKB = event.model as ModelKB;
			if(!_initialized || model.kubeData.faceTop != _lastTopFace) {
				_lastTopFace = model.kubeData.faceTop;
				_initialized = true;
				_kube.leftFace = new CubeFace(model.kubeData.faceSides, true);
				_kube.rightFace = new CubeFace(model.kubeData.faceSides);
				_kube.frontFace = new CubeFace(model.kubeData.faceSides, true);
				_kube.backFace = new CubeFace(model.kubeData.faceSides);
				_kube.topFace = new CubeFace(model.kubeData.faceTop); 
				_kube.bottomFace = new CubeFace(model.kubeData.faceBottom, true);
			}
			
			if(model.kubeSubmitted) {
				parent.addChild(this);//Bring to front dirtyly
				submitTransition();
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			_kubeHolder = addChild(new Sprite()) as Sprite;
			_wingLeft = new WingGraphic();
			_wingRight = new WingGraphic();
			
			_wingLeft.stop();
			_wingRight.stop();
			
			_kube = _kubeHolder.addChild(new Cube()) as Cube;
			_kube.width = _kube.height = _kube.depth = 200;
			
			_wingRight.scaleX = -1;
			_wingLeft.x = -_kube.width * .5;
			_wingRight.x = _kube.width * .5;
			
			filters = [new DropShadowFilter(0,0,0,.25,20,20,1,3)];
			
			_endRX = 40;
			_endRY = 45;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_kube.transform.perspectiveProjection = pp;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			_kubeHolder.x = stage.stageWidth - _kube.width + 20;
			_kubeHolder.y = stage.stageHeight * .5;
		}
		
		/**
		 * Called when mouse is pressed.
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			_pressed = true;
			_rotationOffsets = new Point(_kube.rotationX, _kube.rotationY);
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
			if(_clouds != null) {
				var i:int, len:int, cloud:CloudGraphic;
				len = _clouds.length;
				for(i = 0; i < len; ++i) {
					cloud = _clouds[i];
					cloud.y += cloud.scaleX * _speed;
					if(cloud.y > stage.stageHeight) {
						cloud.x = MathUtils.randomNumberFromRange(-cloud.width * .5, stage.stageWidth - cloud.width * .5);
						cloud.y = MathUtils.randomNumberFromRange(-stage.stageHeight, -cloud.height);
					}
				}
				_speed *= 1.02;
			}else{
				if(_pressed) {
					_endRX = _rotationOffsets.x - (_mouseOffset.y - mouseY);
					_endRY = _rotationOffsets.y + (_mouseOffset.x - mouseX);
				}
				_kube.rotationX += (_endRX - _kube.rotationX) * .1;
				_kube.rotationY += (_endRY - _kube.rotationY) * .1;
				_kube.validate();
			}
		}
		
		/**
		 * Does the transition when the kube is submitted.
		 */
		private function submitTransition():void {
			var i:int, len:int, cloud:CloudGraphic;
			len = 10;
			_clouds = new Vector.<CloudGraphic>(len, true);
			for(i = 0; i < len; ++i) {
				cloud = new CloudGraphic();
				cloud.gotoAndStop(MathUtils.randomNumberFromRange(1, cloud.totalFrames));
				cloud.scaleX = cloud.scaleY = MathUtils.randomNumberFromRange(.25, 1.5);
				cloud.x = MathUtils.randomNumberFromRange(-cloud.width * .5, stage.stageWidth - cloud.width * .5);
				cloud.y = MathUtils.randomNumberFromRange(-stage.stageHeight * 2, -cloud.height);
				addChildAt(cloud, cloud.scaleX > 1? numChildren-1 : 0);
				_clouds[i] = cloud;
			}
			_speed = 10;
			
			_kubeHolder.addChildAt(_wingLeft, 0);
			_kubeHolder.addChildAt(_wingRight, 0);
			
			TweenLite.to(_kube, .25, {shortRotation:{rotationX:45, rotationY:0, rotationZ:0}, onUpdate:_kube.validate});
			TweenLite.to(_kubeHolder, .25, {x:stage.stageWidth * .5, y:stage.stageHeight * .6});
			
			_wingLeft.rotation = 50;
			_wingRight.rotation = -50;
			
			TweenLite.from(_wingLeft, .4, {scaleX:0, delay:.25, ease:Bounce.easeOut});
			TweenLite.from(_wingRight, .4, {scaleX:0, delay:.25, ease:Bounce.easeOut});
			TweenMax.to(_wingLeft, .1, {rotation:-30, yoyo:33, delay:1});
			TweenMax.to(_wingRight, .1, {rotation:30, yoyo:33, delay:1});
			TweenLite.to(_kube, 3, {rotationX:-1000, delay:1, ease:Sine.easeIn, onUpdate:_kube.validate});
			TweenMax.to(_kubeHolder, 3, {ease:Linear.easeNone, bezierThrough:[{x:_kubeHolder.x, y:_kubeHolder.y}, {x:stage.stageWidth * .4, y:stage.stageHeight * .6}, {x:stage.stageWidth * .8, y: -50}], scaleX:.1, scaleY:.1, delay:1, onComplete:onTransitionComplete});
			TweenLite.to(_kubeHolder, 1, {rotation:45, delay:3});
		}
		
		/**
		 * Called when submit transition completes.
		 */
		private function onTransitionComplete():void {
			TweenLite.to(this, .5, {autoAlpha:0});
			FrontControlerKB.getInstance().openResultPage();
		}
		
	}
}