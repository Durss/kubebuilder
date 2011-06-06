package com.muxxu.kube.kuberank.components.form {
	import com.muxxu.kube.common.components.buttons.ButtonKube;
	import com.muxxu.kube.kuberank.components.CubeButtonIcon;
	import com.muxxu.kube.kuberank.controler.FrontControlerKR;
	import com.nurun.components.vo.Margin;
	import com.nurun.structure.environnement.label.Label;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author Francois
	 * @date 2 juin 2011;
	 */
	public class DisplayTypeForm extends Sprite {
		
		[Embed(source="../../assets/top.kub", mimeType="application/octet-stream")]
		private var _crownKube:Class;
		
		[Embed(source="../../assets/vote.kub", mimeType="application/octet-stream")]
		private var _voteKube:Class;
		
		[Embed(source="../../assets/date.kub", mimeType="application/octet-stream")]
		private var _dateKube:Class;
		
		[Embed(source="../../assets/profile.kub", mimeType="application/octet-stream")]
		private var _profileKube:Class;
		
		private var _topBt:ButtonKube;
		private var _dateBt:ButtonKube;
		private var _voteBt:ButtonKube;
		private var _myKubesBt:ButtonKube;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>DisplayTypeForm</code>.
		 */
		public function DisplayTypeForm() {
			initialize();
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Updates the button's states
		 */
		public function update(top3Mode:Boolean, sortByDate:Boolean, searchName:String, profileMode:Boolean):void {
			_topBt.enabled = !top3Mode;
			_voteBt.enabled = sortByDate || top3Mode || searchName.length > 0 || profileMode;
			_dateBt.enabled = !sortByDate || top3Mode || searchName.length > 0 || profileMode;
			_myKubesBt.enabled = !profileMode; //searchName != null && searchName.toLowerCase() != Config.getVariable("uname").toLowerCase();
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function initialize():void {
			_topBt = addChild(new ButtonKube(Label.getLabel("showTop"), true, new CubeButtonIcon(new _crownKube()))) as ButtonKube;
			_dateBt = addChild(new ButtonKube(Label.getLabel("orderByDate"), true, new CubeButtonIcon(new _dateKube()))) as ButtonKube;
			_voteBt = addChild(new ButtonKube(Label.getLabel("orderByVotes"), true, new CubeButtonIcon(new _voteKube()))) as ButtonKube;
			_myKubesBt = addChild(new ButtonKube(Label.getLabel("searchMine"), true, new CubeButtonIcon(new _profileKube()))) as ButtonKube;
			
			_topBt.contentMargin = new Margin(10, 2, 10, 2);
			_voteBt.contentMargin = new Margin(10, 2, 10, 2);
			_dateBt.contentMargin = new Margin(10, 2, 10, 2);
			_myKubesBt.contentMargin = new Margin(10, 2, 10, 2);
			
			_topBt.height = Math.round(_voteBt.height + _dateBt.height);
			_myKubesBt.height = _topBt.height;
			_voteBt.y = Math.round(_dateBt.height);
			_voteBt.x = Math.round(_dateBt.x = _topBt.width);
			_voteBt.width = _dateBt.width = Math.round(Math.max(_voteBt.width, _dateBt.width)) + 5;
			_myKubesBt.x = Math.round(_voteBt.x + _voteBt.width);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Called when a button is clicked.
		 */
		private function clickHandler(event:MouseEvent):void {
			if(event.target == _topBt) {
				FrontControlerKR.getInstance().showTop3();
			}else if(event.target == _voteBt) {
				FrontControlerKR.getInstance().sort(false);
			}else if(event.target == _dateBt) {
				FrontControlerKR.getInstance().sort(true);
			}else if(event.target == _myKubesBt) {
				FrontControlerKR.getInstance().showProfile();
			}
		}
		
	}
}