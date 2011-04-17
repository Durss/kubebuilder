package com.muxxu.kube.kubebuilder.components.panel {
	import com.muxxu.kube.kubebuilder.components.form.colorpicker.ColorPicker;
	import com.muxxu.kube.kubebuilder.components.buttons.KBButton;
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.utils.pos.PosUtils;

	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Francois
	 */
	public class PanelToolsContent extends Sprite {
		private var _copyBt:KBButton;
		private var _pastBt:KBButton;
		private var _resetBt:KBButton;
		private var _fileBt:KBButton;
		private var _colorPicker:ColorPicker;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>PanelToolsContent</code>.
		 */
		public function PanelToolsContent() {
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
			_copyBt = addChild(new KBButton(Label.getLabel("copy"))) as KBButton;
			_pastBt = addChild(new KBButton(Label.getLabel("past"))) as KBButton;
			_resetBt = addChild(new KBButton(Label.getLabel("raz"))) as KBButton;
			_fileBt = addChild(new KBButton(Label.getLabel("image"))) as KBButton;
			
			_colorPicker = addChild(new ColorPicker()) as ColorPicker;
			
			_copyBt.width = 56;
			_pastBt.width = 56;
			_resetBt.width = 56;
			_fileBt.width = 56;
			
			computePositions();
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			PosUtils.hDistribute([_copyBt, _pastBt, _resetBt, _fileBt], 190, 4, 4, true);
			
			//Draw dotted line
			var i:int, len:int, lineWidth:int, py:int;
			py = _fileBt.y + _fileBt.height + 10;
			lineWidth = 7;
			len = 190 / (lineWidth * 2);
			graphics.beginFill(0xffffff, 1);
			for(i = 0; i < len; i++) graphics.drawRect(i*lineWidth*2, py, lineWidth, 1);
			
			_colorPicker.y = py + 10;
		}
		
	}
}