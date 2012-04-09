package com.muxxu.kube.hof.components {
	import flash.events.Event;
	import com.muxxu.kube.kubebuilder.graphics.CloudGraphic;
	import com.nurun.utils.math.MathUtils;

	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 * @date 26 déc. 2011;
	 */
	public class CloudsView extends Sprite {
		
		private var _radiusMin:int;
		private var _radiusMax:int;
		private var _clouds : Vector.<CloudGraphic>;
		private var _angles : Vector.<Number>;
		private var _velocities:Vector.<Number>;
		private var _distances:Vector.<Number>;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CloudsView</code>.
		 */
		public function CloudsView(radiusMin:int, radiusMax:int) {
			_radiusMax = radiusMax;
			_radiusMin = radiusMin;
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
			var i:int, len:int, cloud:CloudGraphic, angle:Number, distance:Number;
			len = 30;
			_clouds = new Vector.<CloudGraphic>(len, true);
			_angles = new Vector.<Number>(len, true);
			_velocities = new Vector.<Number>(len, true);
			_distances = new Vector.<Number>(len, true);
			for(i = 0; i < len; ++i) {
				cloud = addChild(new CloudGraphic()) as CloudGraphic;
				if(Math.random()>.97) {
					if(new Date().getDate() == 1 && new Date().getMonth() == 3) {
						cloud.gotoAndStop(cloud.totalFrames);
					}else{
						cloud.gotoAndStop(cloud.totalFrames-1);
					}
				}else{
					cloud.gotoAndStop(Math.ceil(Math.random() * (cloud.totalFrames-2)));
				}
				
				angle = (i/len)*Math.PI*2;
				distance = MathUtils.randomNumberFromRange(_radiusMin, _radiusMax);
				cloud.x = Math.cos(angle) * distance;
				cloud.y = Math.sin(angle) * distance;
				cloud.rotation = angle * MathUtils.RAD2DEG + 90;
				
				_clouds[i] = cloud;
				_angles[i] = angle;
				_distances[i] = distance;
				_velocities[i] = (Math.random()*.2+.05) * MathUtils.DEG2RAD;
			}
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			var i:int, len:int;
			len = _clouds.length;
			for(i = 0; i < len; ++i) {
				_angles[i] += _velocities[i];
				_clouds[i].x = Math.cos(_angles[i]) * _distances[i];
				_clouds[i].y = Math.sin(_angles[i]) * _distances[i];
				_clouds[i].rotation = _angles[i] * MathUtils.RAD2DEG + 90;
			}
		}
		
	}
}