package com.muxxu.kube.common.vo {
	import flash.geom.Matrix;
	import com.adobe.images.PNGEncoder;
	import com.ion.PNGDecoder;
	import com.muxxu.kube.common.utils.makeKubePreview;
	import com.muxxu.kube.kubebuilder.graphics.DefaultTopFaceGraphic;
	import com.nurun.core.lang.vo.ValueObject;
	import com.nurun.utils.math.MathUtils;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * Stores the data of a .kub file and provides some serialization/deserialization methods.
	 * 
	 * @author Francois
	 */
	public class KUBData implements ValueObject {
		
		[Embed(source="../../assets/corrupted.kub", mimeType="application/octet-stream")]
		private var _curruptKube:Class;
		
		private var _faceTop:BitmapData;
		private var _faceBottom:BitmapData;
		private var _faceSides:BitmapData;
		private var _defaultColor:uint;
		private var _size:int;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>KUBData</code>.
		 */

		public function KUBData(size:int = 16) {
			_size = size;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get faceTop():BitmapData { return _faceTop; }

		public function get faceBottom():BitmapData { return _faceBottom; }

		public function get faceSides():BitmapData { return _faceSides; }

		public function get size():int { return _size; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Resets a face to a default color.
		 */
		public function reset(bmd:BitmapData):void {
			bmd.fillRect(bmd.rect, _defaultColor);
			if(bmd == _faceTop) {
				bmd.draw(new DefaultTopFaceGraphic());
			}
		}
		
		/**
		 * Gets if a face has been modified
		 */
		public function isFaceModified(bmd:BitmapData):Boolean {
			var bmdComp:BitmapData = new BitmapData(_size, _size, true, 0);
			bmdComp.fillRect(bmdComp.rect, _defaultColor);
			if(bmd == _faceTop) {
				bmdComp.draw(new DefaultTopFaceGraphic());
			}
			var diff:Object = bmd.compare(bmdComp);
			if(diff == 0) return false;
			var x:int, y:int, len:int, score:Number, c:uint, pScore:uint, pixelModified:int;
			len = _size;
			score = 0;
			for(x = 0; x < len; ++x) {
				for(y = 0; y < len; ++y) {
					c = BitmapData(diff).getPixel(x, y);
					pScore = ((c >> 16) & 0xff) + ((c >> 8) & 0xff) + (c & 0xff);
					score += pScore;
					if(c > 0) pixelModified ++;
				}
			}
			return pixelModified > 80 || score > 0xff * 80;
		}
		
		/**
		 * Converts the value object to a byteArray
		 */
		public function fromByteArray(data:ByteArray):void {
			try {
				var obj:Array = data.readObject();
			}catch(error:Error) {
				data = new _curruptKube();
				obj = data.readObject();
			}
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
			_faceTop = new BitmapData(_size, _size, true, _defaultColor);
			var mark:DefaultTopFaceGraphic = new DefaultTopFaceGraphic();
			var m:Matrix = new Matrix();
			m.translate(Math.floor((_size - mark.width) * .5), Math.floor((_size - mark.height) * .5));
			
			_faceTop.draw(mark, m);
			_faceBottom = new BitmapData(_size, _size, true, _defaultColor);
			_faceSides = new BitmapData(_size, _size, true, _defaultColor);
		}
	}
}