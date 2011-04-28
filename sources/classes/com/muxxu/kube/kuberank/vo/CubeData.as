package com.muxxu.kube.kuberank.vo {
	import mx.utils.Base64Decoder;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.core.lang.vo.XMLValueObject;
	
	/**
	 * Stores the informations about a cube.
	 * 
	 * @author Francois
	 */
	public class CubeData implements XMLValueObject {
		
		private var _id:Number;
		private var _uid:Number;
		private var _name:String;
		private var _file:String;
		private var _pseudo:String;
		private var _date:Number;
		private var _votes:Number;
		private var _kub:KUBData;
		private var _defaultIndex:int;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeData</code>.
		 */
		public function CubeData(defaultIndex:int) {
			_defaultIndex = defaultIndex;
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get defaultIndex():int { return _defaultIndex; }

		public function get id():Number { return _id; }

		public function get uid():Number { return _uid; }

		public function get name():String { return _name; }

		public function get file():String { return _file; }

		public function get userName():String { return _pseudo; }

		public function get date():Number { return _date; }

		public function get votes():Number { return _votes; }

		public function get kub():KUBData { return _kub; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			_id = parseInt(xml.@id);
			_uid = parseInt(xml.@uid);
			_name = xml.@name;
			_file = xml.@file;
			_pseudo = xml.@pseudo;
			_date = parseInt(xml.@date);
			_votes = parseInt(xml.@votes);
			_kub = new KUBData();
			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(xml[0]);
			_kub.fromByteArray(decoder.drain());
			decoder.reset();
		}
		
		/**
		 * Makes the component garbage collectable.
		 */
		public function dispose():void {
			_kub.dispose();
			_kub = null;
		}
		
		/**
		 * Gets a string representation of the value object.
		 */
		public function toString():String {
			return "[CubeData :: name="+name+"]";
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}