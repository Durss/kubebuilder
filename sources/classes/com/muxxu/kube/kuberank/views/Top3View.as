package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.kuberank.components.CubeResult;
	import flash.geom.Point;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import gs.TweenLite;
	import gs.TweenMax;
	import gs.easing.Linear;

	import com.muxxu.kube.kubebuilder.graphics.PodiumGraphic;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;
	import com.nurun.utils.pos.PosUtils;

	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	/**
	 * Displays the TOP 3 of the rank.
	 * 
	 * @author Francois
	 */
	public class Top3View extends AbstractView {
		
		private var _podium:PodiumGraphic;
		
		
		
		
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
			PosUtils.hCenterIn(this, stage);
			y = 125;
		}
		
		/**
		 * Populates the view
		 */
		private function populate(data:CubeDataCollection):void {
			var positions:Array = [new Point(45, -15), new Point(200, -95), new Point(390, 45)];
			var i:int, len:int, cube:CubeResult, start:Point;
			len = 3;
			for(i = 0; i < len; ++i) {
				start = Point(positions[i]).clone();
				start.y = -300;
				cube = addChild(new CubeResult(data.getItemAt(i), start, positions[i])) as CubeResult;
				TweenLite.delayedCall((3-i)*.5, cube.doOpenTransition);
			}
		}
		
	}
}