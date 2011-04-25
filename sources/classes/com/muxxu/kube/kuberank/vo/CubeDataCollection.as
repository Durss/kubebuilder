package com.muxxu.kube.kuberank.vo {
	import com.nurun.core.collection.Collection;
	import com.nurun.core.lang.vo.XMLValueObject;
	
	/**
	 * 
	 * @author Francois
	 */
	public class CubeDataCollection implements XMLValueObject, Collection {
		
		private var _list:Vector.<CubeData>;
		private var _version:Number;

		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeDataCollection</code>.
		 */
		public function CubeDataCollection() {
			_version = 0;
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * @inheritDoc
		 */
		public function get length():uint { return _list.length; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Clears the data.
		 */
		public function clear():void {
			var i:int, len:int;
			for(i = 0; i < len; ++i) {
				_list[i].dispose();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			_version ++;
			var i:int, len:int, nodes:XMLList;
			nodes = xml.child("kube");
			len = nodes.length();
			_list = new Vector.<CubeData>(len, true);
			for(i = 0; i < len; ++i) {
				_list[i] = new CubeData();
				_list[i].populate(nodes[i]);
			}
		}
		
		/**
		 * Gets an item at a specific index.
		 */
		public function getItemAt(index:int):CubeData {
			return _list[index];
		}
		
		/**
		 * Sorts the items.
		 * 
		 * @param byDate	 if true the items are sorted by date. Else by votes.
		 */
		public function sort(byDate:Boolean):void {
			_version ++;
			_list.sort(byDate? dateSort : votesSort);
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Sorts by date
		 */
		private function dateSort(a:CubeData, b:CubeData):Number {
		    return (a.date > b.date)? 1 : (a.date < b.date)? -1 : 0;
		}
		
		/**
		 * Sorts by votes
		 */
		private function votesSort(a:CubeData, b:CubeData):Number {
		    return (a.votes > b.votes)? 1 : (a.votes < b.votes)? -1 : 0;
		}
		
	}
}