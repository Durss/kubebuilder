package com.muxxu.kube.kubeviewer {
	import com.muxxu.kube.common.components.LoaderSpinning;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.core.lang.boolean.parseBoolean;

	import flash.display.MovieClip;
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
		
		private var _cube:CubeResult;
		private var _spin:LoaderSpinning;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Application</code>.
		 */
		public function KubeViewer() {
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
			_cube = addChild(new CubeResult()) as CubeResult;
			var pos:Point = new Point(0, 0);
			var data:CubeData = new CubeData(0);
			var defaultData:String = '<kube id="12" uid="10793" name="Enceinte" pseudo="Cael" date="1307054559" votes="125" voted=""><![CDATA[CRMBDIIniVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAWklEQVR42mNgYGD4TyFm+J9so0gWxmlAVFQ0VkyUASCFNTW1WDG6IRgGIGtG9ys2Q1AMwKcZlyFYDSAU6iQZ8OzZMzAeOAPI8gLZgUhxNFIlIVElKZOVmSjBABd0mSx8ME6fAAAAAElFTkSuQmCCDAIMAgwCDIIziVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAYElEQVR42mNgYGD4TyFm+J9so0gWRjHA0cmRoIbFSxbDMV4DkBWhGwBSR5QByAqJcgGyBMwAbIYQFQbIBuAzhGgDcBlCPwMo8gJFgYgtGpFpshISUQbgS8o4DaAoM1GCAX1XvHgb5l3XAAAAAElFTkSuQmCCDIEjiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGElEQVR42mNgYGD4TyEeNWDUgFEDhocBAJvM/wFK6ATsAAAAAElFTkSuQmCCBAAEAAyCJ4lQTkcNChoKAAAADUlIRFIAAAAQAAAAEAgGAAAAH/P/YQAAAFpJREFUeNpjYGBg+E8hZvifbKNIFsZpQFRUNFZMlAEghTU1tVgxuiEYBiBrRvcrNkNQDMCnGZchWA0gFOokGfDs2TMwHjgDyPIC2YFIcTRSJSFRJSmTlZkowQAXdJksfDBOnwAAAABJRU5ErkJggg==]]></kube>';
			var cubeData:String = loaderInfo.parameters["kube"] == undefined? defaultData : loaderInfo.parameters["kube"];
			data.populate(new XML(cubeData));
			_cube.populate(data, pos, pos);
			_cube.doOpeningTransition(0, true);
			
			_cube.x = stage.stageWidth * .5;
			_cube.y = stage.stageHeight * .45;
			
			if(loaderInfo.parameters["nextKube"] != undefined) {
				setTimeout(ExternalInterface.call, 100, "populate", loaderInfo.parameters["nextKube"]);
			}
			
			_spin.close();
		}
		
	}
}