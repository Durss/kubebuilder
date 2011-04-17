package com.muxxu.kube.kubebuilder.model {
	import flash.display.BitmapData;
	import com.muxxu.kube.kubebuilder.vo.KubeData;
	import com.nurun.structure.mvc.model.events.ModelEvent;
	import com.nurun.structure.mvc.model.IModel;

	import flash.events.EventDispatcher;
	
	/**
	 * Application's model.
	 * Manages the data and the different states of the application.
	 * 
	 * @author Francois
	 */
	public class Model extends EventDispatcher implements IModel {
		
		private var _kubeData:KubeData;
		private var _currentFace:BitmapData;
		private var _color:uint;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Model</code>.
		 */
		public function Model() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the kube's data.
		 */
		public function get kubeData():KubeData { return _kubeData; }
		
		/**
		 * Gets the current face.
		 */
		public function get currentFace():BitmapData { return _currentFace; }
		
		/**
		 * Gets the current edition color.
		 */
		public function get color():uint { return _color; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Starts the application.
		 */
		public function start():void {
			update();
		}
		
		/**
		 * Sets the current edition's color.
		 */
		public function setCurrentColor(color:uint):void {
			_color = color;
			update();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_kubeData = new KubeData();
			_currentFace = _kubeData.faceSides;
		}
		
		/**
		 * Fires an update to the views.
		 */
		private function update():void {
			dispatchEvent(new ModelEvent(ModelEvent.UPDATE, this));
		}
		
	}
}