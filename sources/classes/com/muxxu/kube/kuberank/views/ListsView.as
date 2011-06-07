package com.muxxu.kube.kuberank.views {
	import com.nurun.structure.environnement.label.Label;
	import com.muxxu.kube.kuberank.vo.ListDataCollection;
	import flash.events.MouseEvent;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import gs.TweenLite;

	import com.muxxu.kube.common.components.ScrollbarKube;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.common.components.form.input.InputKube;
	import com.muxxu.kube.kubebuilder.graphics.CreateIconGraphic;
	import com.muxxu.kube.kuberank.components.form.ListEntry;
	import com.muxxu.kube.kuberank.model.ModelKR;
	import com.muxxu.kube.kuberank.vo.ListData;
	import com.nurun.components.form.events.FormComponentEvent;
	import com.nurun.components.scroll.ScrollPane;
	import com.nurun.components.scroll.scrollable.ScrollableDisplayObject;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.mvc.model.events.IModelEvent;
	import com.nurun.structure.mvc.views.AbstractView;

	import flash.events.Event;

	/**
	 * Displays the lists template.
	 * Provides a way to create and delete lists of kubes.
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
		private var _spool:Vector.<ListEntry>;
		
		
		
		
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
				populate(model.lists);
				TweenLite.to(this, .5, {autoAlpha:1, delay:.25});
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
			_spool = new Vector.<ListEntry>();
			
			_createList = addChild(new ButtonKube(Label.getLabel("listNewSubmit"), true, new CreateIconGraphic())) as ButtonKube;
			_input = addChild(new InputKube(Label.getLabel("listNewInput"), true)) as InputKube;
			_title = addChild(new CssTextField("listsTitle")) as CssTextField;
			_list = new ScrollableDisplayObject();
			_scrollpane = addChild(new ScrollPane(_list, new ScrollbarKube())) as ScrollPane;
			_scrollpane.autoHideScrollers = true;
			
			_title.text = Label.getLabel("listTitle");
			_input.textfield.maxChars = 25;
			
			var data:ListData = new ListData();
			data.populate(new XML("<l id='0'>"+Label.getLabel("listEntryDefault")+"</l>"));
			ListEntry(_list.addChild(new ListEntry(true))).populate(data);
			
			_input.addEventListener(FormComponentEvent.SUBMIT, submitHandler);
			_createList.addEventListener(MouseEvent.CLICK, submitHandler);
			
			computePositions();
		}
		
		/**
		 * Resizes and replaces the elements.
		 */
		private function computePositions():void {
			x = y = 15;
			_input.width = _createList.x = Math.round(840 - _createList.width - 10) - 1;
			_createList.x += 10;
			
			_title.y = Math.round(_createList.height + 10);
			
			_scrollpane.width = 840 + 15;//15 = scrollbar's width
			_scrollpane.height = 300;
			
			_scrollpane.y = _title.y + 41;
			
			graphics.beginFill(0x265367, 1);
			graphics.drawRect(_title.x - 2, _title.y - 2, 840, 40);
			graphics.endFill();
		}
		
		/**
		 * Called when add list form is submitted
		 */
		private function submitHandler(event:Event):void {
			if(String(_input.value).length > 0) {
				FrontControlerKR.getInstance().createList(_input.value as String);
			}
		}
		
		/**
		 * Populates the component
		 */
		private function populate(data:ListDataCollection):void {
			var i:int, len:int, spoolLen:int, dataLen:int;
			dataLen = data.length;
			spoolLen = _spool.length;
			len = Math.max(data.length, spoolLen);
			for(i = 0; i < len; ++i) {
				if(i > spoolLen - 1) {
					_spool[i] = new ListEntry();
				}
				if(i < dataLen) {
					_spool[i].populate(data.getListDataAtIndex(i));
					_list.addChild(_spool[i]).y = (i+1) * 39;
				}else if(contains(_spool[i])){
					_list.removeChild(_spool[i]);
				}
			}
			_scrollpane.validate();
		}
		
	}
}