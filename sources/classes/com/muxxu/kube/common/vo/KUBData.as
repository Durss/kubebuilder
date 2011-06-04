package com.muxxu.kube.common.vo {
	import com.muxxu.kube.common.utils.makeKubePreview;
	import com.nurun.utils.math.MathUtils;
	import com.ion.PNGDecoder;
	import com.adobe.images.PNGEncoder;
	import flash.utils.ByteArray;
	import com.muxxu.kube.kubebuilder.graphics.DefaultTopFaceGraphic;
	import flash.display.BitmapData;
	import com.nurun.core.lang.vo.ValueObject;
	
	/**
	 * Stores the data of a .kub file and provides some serialization/deserialization methods.
	 * 
	 * @author Francois
	 */
	public class KUBData implements ValueObject {
		
		private var _faceTop:BitmapData;
		private var _faceBottom:BitmapData;
		private var _faceSides:BitmapData;
		private var _defaultColor:uint;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KUBData</code>.
		 */
		public function KUBData() {
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
			bmd.fillRect(bmd.rect, _defaultColor);
		}
		
		/**
		 * Converts the value object to a byteArray
		 */
		public function fromByteArray(data:ByteArray):void {
			var obj:Array = data.readObject();
			var decoder:PNGDecoder = new PNGDecoder();
			_faceSides = decoder.decode(obj[3]);
			_faceTop = decoder.decode(obj[4]);
			_faceBottom = decoder.decode(obj[5]);
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
			data[8] = PNGEncoder.encode(makeKubePreview(this));
			ba.writeObject(data);
			return ba;
		}
		
		/**
		 * Makes the component garbage collectable.
		 */
		public function dispose():void {
			_faceTop.dispose();
			_faceBottom.dispose();
			_faceSides.dispose();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_defaultColor = 0xff000000 + MathUtils.randomNumberFromRange(0x555555, 0xffffff);
			_faceTop = new BitmapData(16, 16, true, _defaultColor);
			_faceTop.draw(new DefaultTopFaceGraphic());
			_faceBottom = new BitmapData(16, 16, true, _defaultColor);
			_faceSides = new BitmapData(16, 16, true, _defaultColor);
		}
	}
}