package com.muxxu.kube.kubebuilder.vo {
	import com.adobe.images.PNGEncoder;
	import flash.utils.ByteArray;
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

		public function get faceTop():BitmapData { return _faceTop; }

		public function get faceBottom():BitmapData { return _faceBottom; }

		public function get faceSides():BitmapData { return _faceSides; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Resets a face to a default color.
		 */
		public function reset(bmd:BitmapData):void {
			bmd.fillRect(bmd.rect, 0xffaaaaaa);
		}
		
		/**
		 * Converts the value object to a byteArray
		 */
		public function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			var data:Array = [];
			data[0] = 
			data[1] = 
			data[2] = 
			data[3] = PNGEncoder.encode(_faceSides);
			data[4] = PNGEncoder.encode(_faceTop);
			data[5] = PNGEncoder.encode(_faceBottom);
			data[6] = 0;
			data[7] = 0;
			data[7] = PNGEncoder.encode(_faceSides);//TODO
			ba.writeObject(data);
			return ba;
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_faceTop = new BitmapData(16, 16, true, 0);
			_faceTop.draw(new DefaultTopFaceGraphic());
			_faceBottom = new BitmapData(16, 16, true, 0xffaaaaaa);
			_faceSides = new BitmapData(16, 16, true, 0xffaaaaaa);
		}
	}
}