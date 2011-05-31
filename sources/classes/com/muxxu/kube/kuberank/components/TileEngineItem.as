package com.muxxu.kube.kuberank.components {
	import com.muxxu.kube.kubebuilder.graphics.CubeShadowGraphic;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.tile.ITileEngineItem;
	import com.nurun.core.lang.Disposable;

	import flash.display.Sprite;
	import flash.events.Event;
	
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
		private var _shadow:CubeShadowGraphic;
		private var _cube:BitmapCube;
		
		
		
		
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
			buttonMode = true;//_data.id > -1;
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
			_cube = addChild(new BitmapCube()) as BitmapCube;
			mouseChildren = false;
		}
		
		/**
		 * Called when value object is updated.
		 */
		private function changeDataHandler(event:Event = null):void {
			_cube.populate(_data, _width);
			_shadow.scaleX = _shadow.scaleY = _width/80;
			_shadow.y = _width * .95;
			_shadow.x = Math.round((_cube.width - _shadow.width) * .5);
		}
		
	}
}