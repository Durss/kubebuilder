package com.muxxu.kube.kubebuilder.vo {
	import com.muxxu.kube.kubebuilder.graphics.DefaultTopFaceGraphic;
	import flash.display.BitmapData;
	import com.nurun.core.lang.vo.ValueObject;
	
	/**
	 * 
	 * @author Francois
	 */
	public class KubeData implements ValueObject {
		
		private var _faceTop:BitmapData;
		private var _faceBottom:BitmapData;
		private var _faceSides:BitmapData;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KubeData</code>.
		 */
		public function KubeData() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */

		public function get faceTop():BitmapData { return _faceTop; }

		public function get faceBottom():BitmapData { return _faceBottom; }

		public function get faceSides():BitmapData { return _faceSides; }


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_faceTop = new BitmapData(16, 16, true, 0);
			_faceTop.draw(new DefaultTopFaceGraphic());
			_faceBottom = new BitmapData(16, 16, true, 0xff69AAC7);
			_faceSides = new BitmapData(16, 16, true, 0xff69AAC7);
			_faceSides.setPixel(8, 8, 0xff0000);
		}
	}
}