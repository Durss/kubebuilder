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



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		public function populate(xml:XML, ...optionnals:Array):void {
			_id = parseInt(xml.@id);
			_name = xml[0];
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}