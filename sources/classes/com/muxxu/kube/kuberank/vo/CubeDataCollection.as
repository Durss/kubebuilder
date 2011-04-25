package com.muxxu.kube.kuberank.vo {
	import com.nurun.core.collection.Collection;
	import com.nurun.core.lang.vo.XMLValueObject;
	
	/**
	 * Stores a collection of CubeData instances.
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
		
		/**
		 * Gets the current data version number
		 */
		public function get version():Number { return _version; }



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
				_list[i] = new CubeData(i);
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
		
		/**
		 * Gets a string representation of the value object.
		 */
		public function toString():String {
			return "[CubeDataCollection :: collection="+_list+"]";
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Sorts by date
		 */
		private function dateSort(a:CubeData, b:CubeData):Number {
			if(a.date == b.date) {
			    return defaultSort(a,b);
			}else{
			    return (a.date > b.date)? 1 : (a.date < b.date)? -1 : 0;
			}
		}
		
		/**
		 * Sorts by votes
		 */
		private function votesSort(a:CubeData, b:CubeData):Number {
			if(a.votes == b.votes) {
			    return defaultSort(a,b);
			}else{
			    return (a.votes > b.votes)? 1 : (a.votes < b.votes)? -1 : 0;
			}
		}
		
		/**
		 * Sorts by default indexes
		 */
		private function defaultSort(a:CubeData, b:CubeData):Number {
			return (a.defaultIndex > b.defaultIndex)? 1 : (a.defaultIndex < b.defaultIndex)? -1 : 0;
		}
		
	}
}