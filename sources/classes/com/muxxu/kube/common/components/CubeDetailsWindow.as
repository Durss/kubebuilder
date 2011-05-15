package com.muxxu.kube.common.components {
	import flash.filters.DropShadowFilter;
	import com.nurun.components.invalidator.Invalidator;
	import com.nurun.components.invalidator.Validable;
	import com.muxxu.kube.kuberank.vo.CubeData;
	import com.nurun.components.text.CssTextField;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.date.DateUtils;

	import flash.display.Sprite;
	
	/**
	 * Displays a kube's informations
	 * 
	 * @author Francois
	 */
	public class CubeDetailsWindow extends Sprite implements Validable {
		
		private var _background:BackWindow;
		private var _infos:CssTextField;
		private var _width:Number;
		private var _height:Number;
		private var _displayLeft:Boolean;
		private var _invalidator:Invalidator;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>CubeDetailsWindow</code>.
		 */
		public function CubeDetailsWindow() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Sets the width of the component without simply scaling it.
		 */
		override public function set width(value:Number):void {
			_width = value;
			_invalidator.invalidate();
		}
		
		/**
		 * Sets the height of the component without simply scaling it.
		 */
		override public function set height(value:Number):void {
			_height = value;
			_invalidator.invalidate();
		}
		
		/**
		 * Gets the width of the component.
		 */
		override public function get width():Number { return _width; }
		
		/**
		 * Gets the height of the component.
		 */
		override public function get height():Number { return _height; }
		
		/**
		 * Sets if the component should show the content at the left. Else it's at right
		 */
		public function set displayLeft(value:Boolean):void {
			_displayLeft = value;
			_invalidator.invalidate();
		}



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Populates the component
		 */
		public function populate(data:CubeData):void {
			var details:String;

			if(data.id > -1) {
				var date:Date = new Date(data.date * 1000);
				if(new Date().getDay() == date.getDay() && new Date().getTime() - date.getTime() < 24 * 60 * 60 * 1000) {
					details = Label.getLabel("kubeDetailsToday");
					details = details.replace(/\{DATE\}/gi, DateUtils.format(date, "_h_:_i_"));
				}else{
					details = Label.getLabel("kubeDetails");
					details = details.replace(/\{DATE\}/gi, DateUtils.format(date, "_w_/_m_/_Y_"));
				}
				details = details.replace(/\{KUBE_NAME\}/gi, data.name);
				details = details.replace(/\{USER_ID\}/gi, data.uid);
				details = details.replace(/\{USER_NAME\}/gi, data.userName);
			}else{
				details = Label.getLabel("clickToCreate");
			}
			_infos.text = details;
			
			_invalidator.invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		public function validate():void {
			_invalidator.flagAsValidated();
			computePositions();
		}
		

		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_invalidator = new Invalidator(this);
			_background = addChild(new BackWindow()) as BackWindow;
			_infos = addChild(new CssTextField("kubeDetails")) as CssTextField;
			
			filters = [new DropShadowFilter(4,135,0,.25,5,5,1,3)];
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_infos.width = 150;
			_background.width = _width;
			_background.height = _height;
			_infos.x = _displayLeft? 15 : Math.round(_width - _infos.width - 15);
			_infos.y = Math.round((_height - _infos.height) * .5);
		}
		
	}
}