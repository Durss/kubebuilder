package com.muxxu.kube.kuberank.vo {
	import com.nurun.structure.mvc.vo.ValueObjectElement;
	import com.nurun.core.collection.Collection;
	import com.nurun.core.lang.vo.XMLValueObject;
	
	/**
	 * 
	 * @author Francois
	 * @date 6 juin 2011
	 */
	public class ListDataCollection extends ValueObjectElement implements XMLValueObject, Collection {
		
		private var _collection:Vector.<ListData>;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListDataCollection</code>.
		 */
		public function ListDataCollection() { }

		
		
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
			nodes = xml.child("l");
			len = nodes.length();
			_collection = new Vector.<ListData>(len, true);
			for(i = 0; i < len; ++i) {
				_collection[i] = new ListData();
				_collection[i].populate(nodes[i]);
			}
		}
		
		/**
		 * Gets an item at a specific index.
		 */
		public function getListDataAtIndex(index:int):ListData {
			return _collection[index];
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}