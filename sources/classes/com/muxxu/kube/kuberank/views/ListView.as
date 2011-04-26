package com.muxxu.kube.kuberank.views {
	import com.nurun.utils.pos.PosUtils;
	import gs.TweenLite;

	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.geom.Point;
	
	/**
	 * 
	 * @author Francois
	 */
	public class ListView extends AbstractView {
		private var _lastVersion:Number;
		private var _cubes:Vector.<CubeResult>;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListView</code>.
		 */
		public function ListView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * @inheritDoc
		 */
		override public function update(event:IModelEvent):void {
			var model:ModelKR = event.model as ModelKR;
			if(!model.top3Mode) {
				if(model.data.version == _lastVersion) return;
				_lastVersion = model.data.version;
				TweenLite.to(this, .25, {autoAlpha:1});
				populate(model.data);
			}else{
				TweenLite.to(this, .25, {autoAlpha:0});
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initializes the class.
		 */
		private function initialize():void {
			var i:int, len:int;
			len = 6 * 3;
			_cubes = new Vector.<CubeResult>(len, true);
			for(i = 0; i < len; ++i) {
				_cubes[i] = new CubeResult();
			}
			
			alpha = 0;
			visible = false;
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection):void {
			var i:int, len:int, dataLen:int, cube:CubeResult;
			len = _cubes.length;
			dataLen = data.length;
			for(i = 0; i < len; ++i) {
				cube = _cubes[i];
				if(i < dataLen) {
					cube.x = (i%6) * 140 + 85;
					cube.y = Math.floor(i/6) * 130 + 70;
					cube.populate(data.getItemAt(i), new Point(cube.x, -200), new Point(cube.x, cube.y), 75);
					TweenLite.killDelayedCallsTo(cube.doOpenTransition);
					TweenLite.delayedCall(i*.2, cube.doOpenTransition, [(len-i+1)*.2]);
					addChild(cube);
				}else{
					if(contains(cube)) removeChild(cube);
				}
			}
			
		}
		
	}
}