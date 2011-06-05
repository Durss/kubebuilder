package com.muxxu.kube.kuberank.views {
	import com.muxxu.kube.common.components.form.input.InputKube;
	import com.muxxu.kube.kuberank.vo.ListData;
	import gs.TweenLite;

	import com.muxxu.kube.common.components.ScrollbarKube;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kubebuilder.graphics.CreateIconGraphic;
	import com.muxxu.kube.kuberank.components.form.ListEntry;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.nurun.components.scroll.ScrollPane;
	import com.nurun.components.scroll.scrollable.ScrollableDisplayObject;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	/**
	 * 
	 * @author Francois
	 * @date 5 juin 2011;
	 */
	public class ListsView extends AbstractView {
		private var _createList:ButtonKube;
		private var _title:CssTextField;
		private var _list:ScrollableDisplayObject;
		private var _scrollpane:ScrollPane;
		private var _input:InputKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>ListsView</code>.
		 */
		public function ListsView() {
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
			if(model.profileMode) {
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
			alpha = 0;
			visible = false;
			
			_createList = addChild(new ButtonKube("Créer", true, new CreateIconGraphic())) as ButtonKube;//TODO
			_input = addChild(new InputKube("List name...")) as InputKube;//TODO
			_title = addChild(new CssTextField("listsTitle")) as CssTextField;
			_list = new ScrollableDisplayObject();
			_scrollpane = addChild(new ScrollPane(_list, new ScrollbarKube())) as ScrollPane;
			_scrollpane.autoHideScrollers = true;
			
			_title.text = "Vos listes de kubes";//TODO
			
			var data:ListData = new ListData();
			data.populate(new XML("<l id='0'>Mes kubes</l>"));//TODO
			_list.addChild(new ListEntry(data, true));
			
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			x = y = 15;
			
			_title.y = Math.round(_createList.height + 10);
			
			_scrollpane.width = 840 + 15;//15 = scrollbar width
			_scrollpane.height = 300;
			
			_scrollpane.y = _title.y + 41;
			
			graphics.beginFill(0x265367, 1);
			graphics.drawRect(_title.x - 2, _title.y - 2, 840, 40);
			graphics.endFill();
		}
		
	}
}