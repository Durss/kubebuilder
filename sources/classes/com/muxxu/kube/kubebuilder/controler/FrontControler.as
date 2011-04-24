package com.muxxu.kube.kubebuilder.controler {
	
	import com.muxxu.kube.kubebuilder.model.Model;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Singleton FrontControler
	 * 
	 * @author Francois
	 */
	public class FrontControler {
		private static var _instance:FrontControler;
		private var _model:Model;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>FrontControler</code>.
		 */
		public function FrontControler(enforcer:SingletonEnforcer) {
			if(enforcer == null) {
				throw new IllegalOperationError("A singleton can't be instanciated. Use static accessor 'getInstance()'!");
			}
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Singleton instance getter.
		 */
		public static function getInstance():FrontControler {
			if(_instance == null)_instance = new  FrontControler(new SingletonEnforcer());
			return _instance;	
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Initialize the controler with the model.
		 */
		public function initialize(model:Model):void {
			_model = model;
		}
		
		/**
		 * Sets the current edition's color.
		 */
		public function setCurrentColor(color:uint):void {
			_model.setCurrentColor(color);
		}
		
		/**
		 * Changes the tool.
		 */
		public function setToolType(toolId:String):void {
			_model.setToolType(toolId);
		}
		
		/**
		 * Sets the current face id to modify.
		 */
		public function setCurrentFace(face:String):void {
			_model.setCurrentFace(face);
		}
		
		/**
		 * Loads a file as texture.
		 */
		public function loadFile():void {
			_model.loadFile();
		}
		
		/**
		 * Resets the image.
		 */
		public function reset():void {
			_model.reset();
		}
		
		/**
		 * Copies the image.
		 */
		public function copy():void {
			_model.copy();
		}
		
		/**
		 * Past the copied image.
		 */
		public function past():void {
			_model.past();
		}
		
		/**
		 * Submits a kube
		 */
		public function submit(name:String, callback:Function):void {
			_model.submit(name, callback);
		}
		
		/**
		 * Redirects the user to the result page
		 */
		public function openResultPage():void {
			_model.openResultPage();
		}
		
		/**
		 * Exports the current face
		 */
		public function exportFace():void {
			_model.exportFace();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}