package com.muxxu.kube.hof.vo {
	import com.nurun.structure.mvc.vo.ValueObjectElement;
	import com.nurun.core.collection.Collection;
	import com.nurun.core.lang.vo.XMLValueObject;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 déc. 2011
	 */
	public class HOFDataCollection extends ValueObjectElement implements XMLValueObject, Collection {
		
		private var _collection:Vector.<HOFData>;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>HOFDataCollection</code>.
		 */
		public function HOFDataCollection() { }

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * @inheritDoc
		 */
		public function get length():uint {
			return _collection!=null? _collection.length : 0;
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			var i:int, len:int, nodes:XMLList;
			nodes = XML(xml.child("hofs")[0]).child("hof");
			len = nodes.length();
			_collection = new Vector.<HOFData>(len, true);
			for(i = 0; i < len; ++i) {
				_collection[i] = new HOFData();
				_collection[i].populate(nodes[i]);
			}
		}
		
		/**
		 * Gets an item at a specific index.
		 */
		public function getHOFDataAtIndex(index:int):HOFData {
			return _collection[index];
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}