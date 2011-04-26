package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Linear;

	import com.muxxu.kube.kubebuilder.graphics.PodiumGraphic;
	import com.muxxu.kube.kuberank.components.CubeResult;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.pos.PosUtils;

	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	/**
	 * Displays the TOP 3 of the rank.
	 * 
	 * @author Francois
	 */
	public class Top3View extends AbstractView {
		
		private var _podium:PodiumGraphic;
		private var _cubes:Vector.<CubeResult>;
		private var _lastVersion:Number;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>Top3View</code>.
		 */
		public function Top3View() {
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
			if(model.top3Mode) {
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
			alpha = 0;
			visible = false;
			
			_podium = addChild(new PodiumGraphic()) as PodiumGraphic;
			_podium.filters = [new DropShadowFilter(20,270,0xffffff,.1,0,20,1,2)];
			TweenMax.to(_podium, 2, {ease:Linear.easeNone, yoyo:0, dropShadowFilter:{distance:50, blurY:50, alpha:.25, index:0}});
			
			var i:int, len:int, cube:CubeResult;
			len = 3;
			_cubes = new Vector.<CubeResult>(len, true);
			for(i = 0; i < len; ++i) {
				cube = addChildAt(new CubeResult(), 1) as CubeResult;
				_cubes[i] = cube;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Called when the stage is available.
		 */
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, computePositions);
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions(event:Event = null):void {
			x = Math.round((stage.stageWidth - _podium.width) * .5);
			y = 135;
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection):void {
			var i:int, len:int, start:Point;
			var positions:Array = [new Point(270, -30), new Point(100, 15), new Point(430, 70)];
			var sizes:Array = [77, 66, 55];
			len = 3;
			for(i = 0; i < len; ++i) {
				start = Point(positions[i]).clone();
				start.y = -250;
				_cubes[i].populate(data.getItemAt(i), start, positions[i], sizes[i]);
				TweenLite.killDelayedCallsTo(_cubes[i].doOpenTransition);
				TweenLite.delayedCall((3-i)*.5, _cubes[i].doOpenTransition, [(len-i)*.5 - (3-i)*.5]);
			}
			computePositions();
		}
		
	}
}