package com.muxxu.kube.kuberank.views {
	import gs.TweenLite;

	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kubebuilder.graphics.GradientMenuSplitter;
	import com.muxxu.kube.kuberank.components.BitmapCube;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.CubeDataCollection;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 
	 * @author Francois
	 * @date 29 mai 2011;
	 */
	public class LastKubesView extends AbstractView {
		
		[Embed(source="../../assets/next.kub", mimeType="application/octet-stream")]
		private var _nextKubeClass:Class;
		private var _spool:Vector.<BitmapCube>;
		private var _holder:Sprite;
		private var _label:CssTextField;
		private var _splitter:GradientMenuSplitter;
		private var _nextBt:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>LastOnesView</code>.
		 */
		public function LastKubesView() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Called on model's update
		 */
		override public function update(event:IModelEvent):void {
			var model:ModelKR = event.model as ModelKR;
			TweenLite.killTweensOf(this);
			
			if(model.top3Mode) {
				populate(model.data);
				TweenLite.to(this, .5, {autoAlpha:1});
			}else{
				TweenLite.to(this, .5, {autoAlpha:0});
			}
		}



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
			_splitter = addChild(new GradientMenuSplitter()) as GradientMenuSplitter;
			_label = addChild(new CssTextField("lastKubesTitle")) as CssTextField;
			_nextBt = addChild(new ButtonKube(Label.getLabel("lastKubesNext"), true)) as ButtonKube;
			_spool = new Vector.<BitmapCube>();
			_holder = addChild(new Sprite()) as Sprite;
			_holder.buttonMode = true;
			
			_label.text = Label.getLabel("lastKubesTitle");
			_label.rotation = -90;
			_splitter.width = 420;
			_splitter.rotation = -90;
			_nextBt.width = _nextBt.height = 40;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
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
		 * Resize and replace the elements.
		 */
		private function computePositions(event:Event = null):void {
			_holder.x = _label.width;
			_label.y = Math.round((420 - _label.height) * .5 + _label.height);//420 = menu's Y position
			_splitter.y = _splitter.height;
			
			graphics.clear();
			graphics.beginFill(0x2E7796, 1);
			graphics.drawRect(_holder.x, _nextBt.y - 6, _holder.width, 2);
			
			x = Math.round(stage.stageWidth - width);
		}
		
		/**
		 * Called when a cube is clicked
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _nextBt) {
				FrontControlerKR.getInstance().sort(true);
			}else if(event.target is BitmapCube) {
				FrontControlerKR.getInstance().openKube(BitmapCube(event.target).data);
			}
		}
		
		/**
		 * Populates the component.
		 */
		private function populate(data:CubeDataCollection):void {
			var i:int, len:int, offset:int, item:BitmapCube;
			len = data.length;
			
			offset = 3;
			//create missing objects
			for(i = offset + _spool.length; i < len; ++i) {
				_spool[i - offset] = new BitmapCube();
			}
			
			//Remove all the items
			while(_holder.numChildren > 0) { _holder.removeChildAt(0); }
			
			//add the necessary items and populate them
			for(i = offset; i < len; ++i) {
				item = _spool[i - offset];
				_holder.addChild(item);
				item.populate(data.getItemAt(i), 32, true);
				item.y = 45 * (i - offset);
			}
			_holder.addChild(_nextBt);
			_nextBt.y = 45 * (i - offset) + 10;
			_nextBt.x = Math.round((_holder.width - _nextBt.width) * .5);
			
			computePositions();
		}
		
	}
}