package com.muxxu.kube.kuberank.vo {

	import com.nurun.core.collection.Element;
	import com.nurun.core.lang.vo.XMLValueObject;
	import com.nurun.structure.mvc.vo.ValueObjectElement;
	
	/**
	 * 
	 * @author Francois
	 * @date 6 juin 2011;
	 */
	public class ListData extends ValueObjectElement implements Element, XMLValueObject {
		
		private var _id:int;
		private var _name:String;
		private var _kubes:Array;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListData</code>.
		 */
		public function ListData() { }

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */

		public function get id():int { return _id; }

		public function get name():String { return _name; }

		public function get kubes():Array { return _kubes; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			_id = parseInt(xml.@id);
			_name = String(xml[0]).replace("<", "&lt;").replace(">", "&gt;");
			_kubes = String(xml.@kubes).split(",");
			_kubes.pop();//Remove last empty entry. Due to simple concatenation server-side : kubes = kubes + "ID,";
		}
		
		/**
		 * Gets a string representation of the value object.
		 */
		public function toString():String {
			return "[ListData :: name="+name+"]";
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}