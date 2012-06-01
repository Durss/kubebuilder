package com.muxxu.kube.kubebuilder.model {
	import com.adobe.images.PNGEncoder;
	import com.muxxu.kube.common.vo.KUBData;
	import com.muxxu.kube.kubebuilder.cmd.SubmitKubeCmd;
	import com.muxxu.kube.kubebuilder.vo.FaceIds;
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
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	
	/**
	 * Application's model.
	 * Manages the data and the different states of the application.
	 * 
	 * @author Francois
	 */
	public class ModelKB extends EventDispatcher implements IModel {
		
		private var _kubeData:KUBData;
		private var _currentFace:BitmapData;
		private var _color:uint;
		private var _currentTool:String;
		private var _fr:FileReference;
		private var _browseMode:Boolean;
		private var _imageLoader:Loader;
		private var _copy:BitmapData;
		private var _imageModified:Boolean;
		private var _postKubeCallback:Function;
		private var _kubeSubmitted:Boolean;
		private var _currentFaceId:String;
		private var _textureSize:int;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Model</code>.
		 */
		public function ModelKB() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the kube's data.
		 */
		public function get kubeData():KUBData { return _kubeData; }
		
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
		
		/**
		 * Gets if a kube has been submitted.
		 */
		public function get kubeSubmitted():Boolean { return _kubeSubmitted; }
		
		/**
		 * Gets the texture's size
		 */
		public function get textureSize():int { return _textureSize; }



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
			_currentFaceId = face;
			switch(face){
				case FaceIds.TOP:
					_currentFace = _kubeData.faceTop;
					break;
				case FaceIds.BOTTOM:
					_currentFace = _kubeData.faceBottom;
					break;
				default:
					if(_textureSize == 32) {
						_currentFace = _kubeData.faceLeft;
						break;
					}
				case FaceIds.LEFT:
					_currentFace = _kubeData.faceLeft;
					break;
				case FaceIds.RIGHT:
					_currentFace = _kubeData.faceRight;
					break;
				case FaceIds.FRONT:
					_currentFace = _kubeData.faceFront;
					break;
				case FaceIds.BACK:
					_currentFace = _kubeData.faceBack;
					break;
			}
			update();
		}
		
		/**
		 * Loads a file as texture.
		 */
		public function loadFile():void {
			_browseMode = true;
			_fr.browse([new FileFilter("Image file (JPG, PNG, GIF)", "*.jpg;*.jpeg;*.png;*.gif")]);
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
		public function paste():void {
			if(_copy != null) {
				_currentFace.copyPixels(_copy, _copy.rect, new Point(0,0));
				_imageModified = true;
				update();
				_imageModified = false;
			}
		}
		
		/**
		 * Exports the current face as an image.
		 */
		public function exportFace():void {
			_browseMode = false;
			_fr.save(PNGEncoder.encode(_currentFace), "face.png");
		}
		
		/**
		 * Downloads the .kub file
		 */
		public function downloadKub():void {
			_browseMode = false;
			_fr.save(_kubeData.toByteArray(), "kube.kub");
		}
		
		/**
		 * Uploads a .kub file
		 */
		public function uploadKub():void {
			_browseMode = true;
			_fr.browse([new FileFilter(".KUB file", "*.kub")]);
		}
		
		/**
		 * Submits a kube
		 */
		public function submit(name:String, callback:Function):void {
			if(_kubeSubmitted) return;
			
			var cmd:SubmitKubeCmd = new SubmitKubeCmd(Config.getPath("postKube"), name, _kubeData);
			cmd.addEventListener(CommandEvent.COMPLETE, postKubeCompleteHandler);
			cmd.execute();
			_postKubeCallback = callback;
		}
		
		/**
		 * Redirects the user to the result page
		 */
		public function openResultPage():void {
			if(ExternalInterface.available) {
				navigateToURL(new URLRequest(Config.getPath("resultPage")), "_self");
			}
		}
		
		/**
		 * Called when the user wants to read the informations
		 */
		public function readInfos():void {
			navigateToURL(new URLRequest(Config.getPath("infosUrl")), "_self");
		}
		
		/**
		 * Gets if a kube can be submitted or not
		 */
		public function isSubmitable():Boolean {
			if(!_kubeData.isFaceModified(_kubeData.faceTop)) {
				setCurrentFace(FaceIds.TOP);
				return false;
			}else if(!_kubeData.isFaceModified(_kubeData.faceBottom)) {
				setCurrentFace(FaceIds.BOTTOM);
				return false;
			}else {
				if(_textureSize == 16) {
					if(!_kubeData.isFaceModified(_kubeData.faceFront)) {
						setCurrentFace(FaceIds.FRONT);
						return false;
					}
				}else  if(_textureSize == 32) {
					if(!_kubeData.isFaceModified(_kubeData.faceFront)) {
						setCurrentFace(FaceIds.FRONT);
						return false;
					}else if(!_kubeData.isFaceModified(_kubeData.faceBack)) {
						setCurrentFace(FaceIds.BACK);
						return false;
					}else if(!_kubeData.isFaceModified(_kubeData.faceLeft)) {
						setCurrentFace(FaceIds.LEFT);
						return false;
					}else if(!_kubeData.isFaceModified(_kubeData.faceRight)) {
						setCurrentFace(FaceIds.RIGHT);
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * Toggles the textures size
		 */
		public function toggleSize():void {
			_textureSize = _textureSize == 16? 32 : 16;
			_kubeData = new KUBData(_textureSize);
			_currentFace = _kubeData.faceFront;
			update();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_textureSize = 16;
			_kubeData = new KUBData(_textureSize);
			_currentFace = _kubeData.faceFront;
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
				if(/.*\.kub$/gi.test(_fr.name)) {
					_kubeData.fromByteArray(_fr.data);
					_textureSize = _kubeData.size;
					trace('_textureSize: ' + (_textureSize));
					setCurrentFace(_currentFaceId);
				}else{
					_imageLoader.loadBytes(_fr.data);
				}
			}
		}
		
		
		
		
		//__________________________________________________________ IMAGE LOADER HANDLERS
		
		/**
		 * Called when image's loading completes
		 */
		private function loadImageCompleteHandler(event:Event):void {
			var bmd:BitmapData = Bitmap(_imageLoader.content).bitmapData;
			var m:Matrix = new Matrix();
			m.scale(_textureSize / bmd.width, _textureSize / bmd.height);
			_currentFace.fillRect(_currentFace.rect, 0);
			_currentFace.draw(bmd, m);
			
			//Remove alpha
			var i:int, lenI:int, lenJ:int, j:int, color:uint;
			lenI = _currentFace.width;
			lenJ = _currentFace.height;
			for(i = 0; i < lenI; ++i) {
				for(j = 0; j < lenJ; ++j) {
					color = _currentFace.getPixel32(i, j);
					if((color >>> 24) > 0xff * .4) {
						_currentFace.setPixel32(i, j, 0xff000000 + (color & 0x00ffffff));
					}else{
						_currentFace.setPixel32(i, j, 0x00ffffff & color);
					}
				}
			}
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
			_kubeSubmitted = true;
			update();
		}
	}
}