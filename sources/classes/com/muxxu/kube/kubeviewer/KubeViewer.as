package com.muxxu.kube.kubeviewer {
	import com.muxxu.kube.common.components.LoaderSpinning;
	import com.muxxu.kube.common.utils.makeKubePreview;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.core.lang.boolean.parseBoolean;

	import mx.utils.Base64Encoder;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * Bootstrap class of the application.
	 * Must be set as the main class for the flex sdk compiler
	 * but actually the real bootstrap class will be the factoryClass
	 * designated in the metadata instruction.
	 * 
	 * @author Francois
	 * @date 3 juin 2011;
	 */
	 
	[SWF(width="150", height="160", backgroundColor="0x9693BF", frameRate="31")]
	public class KubeViewer extends MovieClip {
		
		[Embed(source="../../assets/rubix.kub", mimeType="application/octet-stream")]
		private var _default:Class;
		
		private var _cube:CubeResult;
		private var _spin:LoaderSpinning;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.
		 */
		public function KubeViewer() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_spin = addChild(new LoaderSpinning()) as LoaderSpinning;
			
			if(ExternalInterface.available) {
				ExternalInterface.addCallback("populate", populate);
			}else{
				populate();
			}
			
			_spin.open();
			_spin.x = stage.stageWidth * .5;
			_spin.y = stage.stageHeight * .5;
		}
		
		/**
		 * Populates the component
		 */
		private function populate():void {
			var data:CubeData = new CubeData(0);
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(new _default());
			var defaultData:String = '<kube id="" uid="" name="" pseudo="" date="" voted=""><![CDATA['+encoder.drain()+']]></kube>';
			var cubeData:String = loaderInfo.parameters["kube"] == undefined? defaultData : loaderInfo.parameters["kube"];
			data.populate(new XML(cubeData));
			
			if(parseBoolean(loaderInfo.parameters["light"])) {
				addChild(new Bitmap(makeKubePreview(data.kub)));
				ExternalInterface.call("populate", loaderInfo.parameters["nextKube"]);
			}else{
				_cube = addChild(new CubeResult()) as CubeResult;
				var pos:Point = new Point(0, 0);
				_cube.populate(data, pos, pos);
				_cube.doOpeningTransition(0, true);
				if(stage.loaderInfo.parameters["dragSensitivity"] != undefined) {
					_cube.dragSensitivity = parseFloat(stage.loaderInfo.parameters["dragSensitivity"]);
				}
				
				_cube.x = stage.stageWidth * .5;
				_cube.y = stage.stageHeight * .45;
				
				if(loaderInfo.parameters["nextKube"] != undefined) {
					setTimeout(ExternalInterface.call, 100, "populate", loaderInfo.parameters["nextKube"]);
				}
			}
			_spin.close();
		}
		
	}
}