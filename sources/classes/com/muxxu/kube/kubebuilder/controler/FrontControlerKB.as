package com.muxxu.kube.kubebuilder.controler {
	import com.muxxu.kube.kubebuilder.model.ModelKB;
	import com.nurun.structure.mvc.model.IModel;

	import flash.errors.IllegalOperationError;
	
	
	/**
	 * Singleton FrontControler
	 * 
	 * @author Francois
	 */
	public class FrontControlerKB {
		private static var _instance:FrontControlerKB;
		private var _model:ModelKB;
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>FrontControler</code>.
		 */
		public function FrontControlerKB(enforcer:SingletonEnforcer) {
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
		public static function getInstance():FrontControlerKB {
			if(_instance == null)_instance = new  FrontControlerKB(new SingletonEnforcer());
			return _instance;	
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Initialize the controler with the model.
		 */
		public function initialize(model:IModel):void {
			_model = model as ModelKB;
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
		public function paste():void {
			_model.paste();
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
		
		/**
		 * Downloads the .kub file
		 */
		public function downloadKub():void {
			_model.downloadKub();
		}
		
		/**
		 * Uploads a .kub file
		 */
		public function uploadKub():void {
			_model.uploadKub();
		}
		
		/**
		 * Called when the user wants to read the informations
		 */
		public function readInfos():void {
			_model.readInfos();
		}
		
		/**
		 * Gets if a kube can be submitted or not
		 */
		public function isSubmitable():Boolean {
			return _model.isSubmitable();
		}
		
		/**
		 * Toggles the textures size
		 */
		public function toggleSize():void {
			_model.toggleSize();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		
	}
}

internal class SingletonEnforcer{}