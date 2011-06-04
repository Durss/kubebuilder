package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.structure.environnement.configuration.Config;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.form.events.FormComponentEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.nurun.utils.pos.PosUtils;
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.nurun.components.vo.Margin;
	import com.muxxu.kube.common.components.form.input.InputKube;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.components.text.CssTextField;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 */
	public class SearchForm extends Sprite {
		
		private var _title:CssTextField;
		private var _byNameTitle:CssTextField;
		private var _byKIDTitle:CssTextField;
		private var _nameInput:InputKube;
		private var _kidInput:InputKube;
		private var _nameSubmit:ButtonKube;
		private var _kidSubmit:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>SearchForm</code>.
		 */
		public function SearchForm() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Updates the component's state
		 */
		public function update(username:String, cube:CubeData):void {
			if(username != Config.getVariable("uname") && username.length > 0) {
				_nameInput.text = username;
			}
			if(cube != null) {
//				_kidInput.text = cube.id.toString();
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
			_title = addChild(new CssTextField("menuTitle")) as CssTextField;
			_byNameTitle = addChild(new CssTextField("menuTitleSearchLabel")) as CssTextField;
			_byKIDTitle = addChild(new CssTextField("menuTitleSearchLabel")) as CssTextField;
			_nameInput = addChild(new InputKube(Label.getLabel("searchByNameInput"))) as InputKube;
			_kidInput = addChild(new InputKube(Label.getLabel("searchByKIDInput"))) as InputKube;
			_nameSubmit = addChild(new ButtonKube(Label.getLabel("searchLabel"))) as ButtonKube;
			_kidSubmit = addChild(new ButtonKube(Label.getLabel("searchLabel"))) as ButtonKube;
			
			_nameInput.margins = new Margin(4, 0, 4, 0);
			_kidInput.margins = new Margin(4, 0, 4, 0);
			_nameInput.textfield.maxChars = 12;
			_nameInput.textfield.restrict = "[a-z0-9]\\-_";
			_kidInput.textfield.restrict = "[0-9]";
			_kidInput.textfield.maxChars = 6;
			
			_kidSubmit.enabled = _nameSubmit.enabled = false;
			
			_title.text = Label.getLabel("searchTitle");
			_byNameTitle.text = Label.getLabel("searchByName");
			_byKIDTitle.text = Label.getLabel("searchByKID");
			
			computePositions();
			
			_nameSubmit.addEventListener(MouseEvent.CLICK, submitHandler);
			_kidSubmit.addEventListener(MouseEvent.CLICK, submitHandler);
			_nameInput.addEventListener(FormComponentEvent.SUBMIT, submitHandler);
			_kidInput.addEventListener(FormComponentEvent.SUBMIT, submitHandler);
			_nameInput.addEventListener(Event.CHANGE, changeValueHandler);
			_kidInput.addEventListener(Event.CHANGE, changeValueHandler);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_nameInput.validate();
			_kidInput.validate();
			
			_byNameTitle.y = Math.round(_title.height);
			_nameInput.y = _nameSubmit.y = _byNameTitle.y;
			_byKIDTitle.y = Math.round(_nameInput.y + _nameInput.height + 4);
			_kidInput.y = _kidSubmit.y = _byKIDTitle.y;
			
			_byKIDTitle.width = _byNameTitle.width = Math.max(_byKIDTitle.width, _byNameTitle.width) + 4;
			
			_kidInput.x = _byKIDTitle.width + 5;
			PosUtils.hPlaceNext(5, _byNameTitle, _nameInput, _nameSubmit);
			PosUtils.hPlaceNext(5, _byKIDTitle, _kidInput, _kidSubmit);
			
			_kidSubmit.height = _kidInput.height;
			_nameSubmit.height = _nameInput.height;
		}
		
		/**
		 * Called when a component is clicked.
		 */
		private function submitHandler(event:Event):void {
			if((event.currentTarget == _nameSubmit || event.currentTarget == _nameInput) && _nameSubmit.enabled) {
				FrontControlerKR.getInstance().searchKubesOfUser(_nameInput.value as String);
			}else if((event.currentTarget == _kidSubmit || event.currentTarget == _kidInput) && _kidSubmit.enabled) {
				FrontControlerKR.getInstance().loadKube(_kidInput.value as String);
			}
			stage.focus = null;
		}
		
		/**
		 * Called when an input's value changes.
		 */
		private function changeValueHandler(event:Event):void {
			_nameSubmit.enabled = String(_nameInput.value).length > 0;
			_kidSubmit.enabled = String(_kidInput.value).length > 0;
		}
		
	}
}