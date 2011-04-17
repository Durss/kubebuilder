package com.muxxu.kube.kubebuilder.model {
	import com.muxxu.kube.kubebuilder.cmd.SubmitKubeCmd;
	import com.muxxu.kube.kubebuilder.vo.FaceIds;
	import com.muxxu.kube.kubebuilder.vo.KubeData;
	import com.muxxu.kube.kubebuilder.vo.ToolType;
	import com.nurun.core.commands.events.CommandEvent;
	import com.nurun.structure.environnement.configuration.Config;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.IModel;
	import com.nurun.structure.mvc.model.events.ModelEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
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
		private var _currentTool:String;
		private var _fr:FileReference;
		private var _browseMode:Boolean;
		private var _imageLoader:Loader;
		private var _copy:BitmapData;
		private var _imageModified:Boolean;
		private var _postKubeCallback:Function;
		
		
		
		
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
		
		/**
		 * Gets the current edition tool.
		 */
		public function get tool():String { return _currentTool; }
		
		/**
		 * Gets if th emodel has modified the image. (copy/past, image loading, reset)
		 */
		public function get imageModified():Boolean { return _imageModified; }



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
		
		/**
		 * Changes the tool.
		 */
		public function setToolType(toolId:String):void {
			_currentTool = toolId;
			update();
		}
		
		/**
		 * Sets the current face id to modify.
		 */
		public function setCurrentFace(face:String):void {
			switch(face){
				case FaceIds.TOP:
					_currentFace = _kubeData.faceTop;
					break;
				case FaceIds.BOTTOM:
					_currentFace = _kubeData.faceBottom;
					break;
				default:
				case FaceIds.LEFT:
				case FaceIds.RIGHT:
				case FaceIds.FRONT:
				case FaceIds.BACK:
					_currentFace = _kubeData.faceSides;
					break;
			}
			update();
		}
		
		/**
		 * Loads a file as texture.
		 */
		public function loadFile():void {
			_browseMode = true;
			_fr.browse([new FileFilter("Image file", "*.jpg;*.jpeg;*.png;*.gif")]);
		}
		
		/**
		 * Resets the image.
		 */
		public function reset():void {
			_kubeData.reset(_currentFace);
			_imageModified = true;
			update();
			_imageModified = false;
		}
		
		/**
		 * Copies the image.
		 */
		public function copy():void {
			_copy = _currentFace.clone();
		}
		
		/**
		 * Past the copied image.
		 */
		public function past():void {
			if(_copy != null) {
				_currentFace.copyPixels(_copy, _copy.rect, new Point(0,0));
				_imageModified = true;
				update();
				_imageModified = false;
			}
		}
		
		/**
		 * Submits a kube
		 */
		public function submit(name:String, callback:Function):void {
			var cmd:SubmitKubeCmd = new SubmitKubeCmd(Config.getPath("postKube"), name, _kubeData);
			cmd.addEventListener(CommandEvent.COMPLETE, postKubeCompleteHandler);
			cmd.execute();
			_postKubeCallback = callback;
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
			_currentTool = ToolType.PENCIL;
			
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, selectFileHandler);
			_fr.addEventListener(Event.COMPLETE, loadFileCompleteHandler);
			
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageCompleteHandler);
			_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadImageErrorHandler);
		}
		
		/**
		 * Fires an update to the views.
		 */
		private function update():void {
			dispatchEvent(new ModelEvent(ModelEvent.UPDATE, this));
		}
		
		
		
		
		//__________________________________________________________ FILE REFERENCE HANDLERS
		
		/**
		 * Called when a file is selected
		 */
		private function selectFileHandler(event:Event):void {
			if(_browseMode) {
				_fr.load();
			}
		}

		private function loadFileCompleteHandler(event:Event):void {
			if(_browseMode) {
				_imageLoader.loadBytes(_fr.data);
			}
		}
		
		
		
		
		//__________________________________________________________ IMAGE LOADER HANDLERS
		
		/**
		 * Called when image's loading completes
		 */
		private function loadImageCompleteHandler(event:Event):void {
			var bmd:BitmapData = Bitmap(_imageLoader.content).bitmapData;
			var m:Matrix = new Matrix();
			m.scale(16 / bmd.width, 16 / bmd.height);
			_currentFace.draw(bmd, m);
			_imageModified = true;
			update();
			_imageModified = false;
		}
		
		/**
		 * Called if image's loading fails
		 */
		private function loadImageErrorHandler(event:IOErrorEvent):void {
			event.stopPropagation();
			event.preventDefault();
			throw new Error(Label.getLabel("errorImageLoading"));
		}
		
		/**
		 * Called when kube post completes
		 */
		private function postKubeCompleteHandler(event:CommandEvent):void {
			_postKubeCallback();
		}
	}
}