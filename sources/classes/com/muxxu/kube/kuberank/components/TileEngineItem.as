package com.muxxu.kube.kuberank.components {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.kubebuilder.graphics.CubeShadowGraphic;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.tile.ITileEngineItem;
	import com.nurun.components.volume.Cube;
	import com.nurun.core.lang.Disposable;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * Creates a TileEngine entry for the SmoothListView.
	 * 
	 * @author Francois
	 */
	public class TileEngineItem extends Sprite implements ITileEngineItem {
		
		private var _data:CubeData;
		private var _visibleWidth:Number;
		private var _visibleHeight:Number;
		private var _width:Number;
		private var _cube:Cube;
		private var _shadow:CubeShadowGraphic;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>TileEngineItem</code>.
		 */
		public function TileEngineItem() {
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
		public function setVisibleWidth(value:Number):void {
			_visibleWidth = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setVisibleHeight(value:Number):void {
			_visibleHeight = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setItemWidth(value:Number):void {
			_width = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setData(value:*):void {
			if(_data != null) {
				_data.removeEventListener(Event.CHANGE, changeDataHandler);
			}
			_data = value as CubeData;
			_data.addEventListener(Event.CHANGE, changeDataHandler);
			changeDataHandler();
			buttonMode = _data.id > -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getData():* { return _data; }

		/**
		 * @inheritDoc
		 */
		/**
		 * Makes the component garbage collectable.
		 */
		public function dispose():void {
			while(numChildren > 0) {
				if(getChildAt(0) is Disposable) Disposable(getChildAt(0)).dispose();
				removeChildAt(0);
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_shadow = addChild(new CubeShadowGraphic()) as CubeShadowGraphic;
			_cube = addChild(new Cube()) as Cube;
			
			mouseChildren = false;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_cube.transform.perspectiveProjection = pp;
		}
		
		/**
		 * Called when value object is updated.
		 */
		private function changeDataHandler(event:Event = null):void {
			_cube.rotationX = 20;
			_cube.rotationY = 43;
			_cube.rotationZ = 13;
			
			_cube.width = _cube.height = _cube.depth = _width;
			
			_cube.leftFace = new CubeFace(_data.kub.faceSides);
			_cube.rightFace = new CubeFace(_data.kub.faceSides);
			_cube.frontFace = new CubeFace(_data.kub.faceSides);
			_cube.backFace = new CubeFace(_data.kub.faceSides);
			_cube.topFace = new CubeFace(_data.kub.faceTop); 
			_cube.bottomFace = new CubeFace(_data.kub.faceBottom);
			
			_cube.x = _cube.y = _width * .5;
			
			_shadow.scaleX = _shadow.scaleY = _width/70;
			_shadow.y = _width * .85;
			_shadow.x = _cube.x - _shadow.width * .5;
			
			//Fuckin' hack >_<
			//The top face of the first cubes wasn't displayed properly the first
			//time... so we force the rendering multiple times \o/
			TweenLite.to(this, .25, {onUpdate:_cube.validate});
		}
		
	}
}