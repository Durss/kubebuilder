package com.muxxu.kube.hof.vo {
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.core.collection.Collection;
	import com.nurun.core.lang.vo.XMLValueObject;
	import com.nurun.structure.mvc.vo.ValueObjectElement;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 déc. 2011
	 */
	public class HOFData extends ValueObjectElement implements XMLValueObject, Collection {
		
		private var _collection:Vector.<CubeData>;
		private var _date:Date;
		private var _id:Number;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>HOFData</code>.
		 */
		public function HOFData() { }

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * @inheritDoc
		 */
		public function get length():uint {
			return _collection!=null? _collection.length : 0;
		}
		
		/**
		 * Gets the date
		 */
		public function get date():Date { return _date; }
		
		/**
		 * Gets the HOF ID
		 */
		public function get id():Number { return _id; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			var i:int, len:int, nodes:XMLList;
			nodes = xml.child("kube");
			len = nodes.length();
			_collection = new Vector.<CubeData>(len, true);
			for(i = 0; i < len; ++i) {
				_collection[i] = new CubeData(i);
				_collection[i].populate(nodes[i]);
			}

			var chunks:Array = String(xml.@date).split("-");
			_date = new Date(parseInt(chunks[0]), parseInt(chunks[1])-1, parseInt(chunks[2]));
			_id = parseInt(xml.@id);
		}
		
		/**
		 * Gets an item at a specific index.
		 */
		public function getCubeDataAtIndex(index:int):CubeData {
			return _collection[index];
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}