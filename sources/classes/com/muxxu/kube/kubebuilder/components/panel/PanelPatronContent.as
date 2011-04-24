package com.muxxu.kube.kubebuilder.components.panel {
	import com.muxxu.kube.common.vo.KubeData;
	import com.muxxu.kube.kubebuilder.controler.FrontControlerKB;
	import com.muxxu.kube.kubebuilder.vo.FaceIds;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Linear;


	
	/**
	 * 
	 * @author Francois
	 */
	public class PanelPatronContent extends Sprite {
		
		private var _sidesCtn:Sprite;
		private var _left:Sprite;
		private var _right:Sprite;
		private var _top:Sprite;
		private var _bottom:Sprite;
		private var _front:Sprite;
		private var _back:Sprite;
		private var _leftBmp:Bitmap;
		private var _rightBmp:Bitmap;
		private var _topBmp:Bitmap;
		private var _bottomBmp:Bitmap;
		private var _frontBmp:Bitmap;
		private var _backBmp:Bitmap;
		
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PatronContent</code>.
		 */
		public function PanelPatronContent() {
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
		public function populate(data:KubeData):void {
			_frontBmp.bitmapData = data.faceSides;
			_leftBmp.bitmapData = data.faceSides;
			_rightBmp.bitmapData = data.faceSides;
			_backBmp.bitmapData = data.faceSides;
			_topBmp.bitmapData = data.faceTop;
			_bottomBmp.bitmapData = data.faceBottom;
			
			computePositions();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_sidesCtn = addChild(new Sprite()) as Sprite;
			_left	= _sidesCtn.addChild(new Sprite()) as Sprite;
			_right	= _sidesCtn.addChild(new Sprite()) as Sprite;
			_top	= _sidesCtn.addChild(new Sprite()) as Sprite;
			_bottom	= _sidesCtn.addChild(new Sprite()) as Sprite;
			_front	= _sidesCtn.addChild(new Sprite()) as Sprite;
			_back	= _sidesCtn.addChild(new Sprite()) as Sprite;
			
			_leftBmp	= _left.addChild(new Bitmap()) as Bitmap;
			_rightBmp	= _right.addChild(new Bitmap()) as Bitmap;
			_topBmp		= _top.addChild(new Bitmap()) as Bitmap;
			_bottomBmp	= _bottom.addChild(new Bitmap()) as Bitmap;
			_frontBmp	= _front.addChild(new Bitmap()) as Bitmap;
			_backBmp	= _back.addChild(new Bitmap()) as Bitmap;
			
			filters = [new GlowFilter(0,.6,2,2,1,3)];
			
			_left.buttonMode = true;
			_right.buttonMode = true;
			_top.buttonMode = true;
			_bottom.buttonMode = true;
			_front.buttonMode = true;
			_back.buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_leftBmp.width = _rightBmp.width = _topBmp.width = _bottomBmp.width = _frontBmp.width = _backBmp.width =
			_leftBmp.height = _rightBmp.height = _topBmp.height = _bottomBmp.height = _frontBmp.height = _backBmp.height = 16 * 4;
			
			_left.x		= _bottom.width + 1;
			_top.x		= _left.x;
			_top.y		= _left.height + 1;
			_back.x		= _top.x + _top.width + 1;
			_back.y		= _top.y;
			_front.y	= _top.y;
			_right.x	= _top.x;
			_right.y	= _top.y + _top.height + 1;
			_bottom.x	= _top.x;
			_bottom.y	= _right.y + _right.height + 1;
			
			_frontBmp.rotation = 90;
			_leftBmp.rotation = 180;
			_topBmp.rotation = 90;
			_backBmp.rotation = -90;
			_bottomBmp.rotation = -90;
			
			_frontBmp.x = _frontBmp.width + 1;
			_frontBmp.y = 1;
			
			_topBmp.x = _topBmp.width + 1;
			_topBmp.y = 1;
			
			_leftBmp.x = _leftBmp.width + 1;
			_leftBmp.y = _leftBmp.height + 1;
			
			_rightBmp.x = 1;
			_rightBmp.y = 1;
			
			_backBmp.x = 1;
			_backBmp.y = _backBmp.height + 1;
			
			_bottomBmp.x = 1;
			_bottomBmp.y = _bottomBmp.height + 1;
			
			_sidesCtn.y = 18;
		}
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		

		/**
		 * Called when a face is rolled over.
		 */
		private function mouseOverHandler(event:MouseEvent):void {
			_top.filters = 
			_left.filters = 
			_right.filters = 
			_bottom.filters = 
			_front.filters = 
			_back.filters = [];
			
			TweenLite.to(event.target, .25, {colorMatrixFilter:{brightness:1.2}});
		}
		
		/**
		 * Called when a face is rolled out.
		 */
		private function mouseOutHandler(event:MouseEvent):void {
			TweenLite.to(event.target, .25, {colorMatrixFilter:{brightness:1, remove:true}});
			TweenMax.to(_top, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
			TweenMax.to(_left, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
			TweenMax.to(_right, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
			TweenMax.to(_front, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
			TweenMax.to(_back, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
			TweenMax.to(_bottom, .5, {colorMatrixFilter:{brightness:1, remove:true}, ease:Linear.easeNone});
		}
		
		/**
		 * Called when a face is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _top) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.TOP);
			} else if(event.target == _left) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.LEFT);
			} else if(event.target == _right) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.RIGHT);
			} else if(event.target == _front) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.FRONT);
			} else if(event.target == _back) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.BACK);
			} else if(event.target == _bottom) {
				FrontControlerKB.getInstance().setCurrentFace(FaceIds.BOTTOM);
			}
		}
		
	}
}