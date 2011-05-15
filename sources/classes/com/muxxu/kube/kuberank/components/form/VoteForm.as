package com.muxxu.kube.kuberank.components.form {
	import com.nurun.structure.environnement.label.Label;
	import com.nurun.components.text.CssTextField;
	import gs.TweenLite;
	import gs.easing.Bounce;

	import com.muxxu.kube.common.components.cube.CubeFace;
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.components.volume.Cube;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * Displays the vote buttons.
	 * Used by the SingleKubeView.
	 * 
	 * @author Francois
	 */
	public class VoteForm extends Sprite {
		
		[Embed(source="../../../../../../../../assets/like.kub", mimeType="application/octet-stream")]
		private var _likeKub:Class;
		[Embed(source="../../../../../../../../assets/dislike.kub", mimeType="application/octet-stream")]
		private var _dislikeKub:Class;
		
		private var _likeBt:Cube;
		private var _dislikeBt:Cube;
		private var _title:CssTextField;
		
		
		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>VoteForm</code>.
		 */
		public function VoteForm() {
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
			_title = addChild(new CssTextField("voteTitle")) as CssTextField;
			
			_title.text = Label.getLabel("voteTitle");
			
			_likeBt = addChild(new Cube()) as Cube;
			_dislikeBt = addChild(new Cube()) as Cube;
			
			_likeBt.width = _likeBt.height = _likeBt.depth = 100;
			_dislikeBt.width = _dislikeBt.height = _dislikeBt.depth = 100;
			
			_likeBt.graphics.beginFill(0xff0000, 0);
			_likeBt.graphics.drawRect(-50, -50, 100, 100);
			_likeBt.graphics.endFill();
			
			_dislikeBt.graphics.beginFill(0xff0000, 0);
			_dislikeBt.graphics.drawRect(-50, -50, 100, 100);
			_dislikeBt.graphics.endFill();
			
			_likeBt.buttonMode = true;
			_dislikeBt.buttonMode = true;
			_likeBt.mouseChildren = false;
			_dislikeBt.mouseChildren = false;
			
			var data:KUBData = new KUBData();
			var ba:ByteArray = new _likeKub();
			data.fromByteArray(ba);
			_likeBt.leftFace = new CubeFace(data.faceSides);
			_likeBt.rightFace = new CubeFace(data.faceSides);
			_likeBt.frontFace = new CubeFace(data.faceSides);
			_likeBt.backFace = new CubeFace(data.faceSides);
			_likeBt.topFace = new CubeFace(data.faceTop); 
			_likeBt.bottomFace = new CubeFace(data.faceBottom);
			
			ba = new _dislikeKub();
			data.fromByteArray(ba);
			_dislikeBt.leftFace = new CubeFace(data.faceSides);
			_dislikeBt.rightFace = new CubeFace(data.faceSides);
			_dislikeBt.frontFace = new CubeFace(data.faceSides);
			_dislikeBt.backFace = new CubeFace(data.faceSides);
			_dislikeBt.topFace = new CubeFace(data.faceTop); 
			_dislikeBt.bottomFace = new CubeFace(data.faceBottom);
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			_likeBt.transform.perspectiveProjection = pp;
			_dislikeBt.transform.perspectiveProjection = pp;
			
			computePositions();
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		/**
		 * Resize and replace the elements.
		 */
		private function computePositions():void {
			_likeBt.x = _likeBt.width * .5;
			_likeBt.y = _likeBt.height * .5 + _title.height + 10;
			_dislikeBt.x = _likeBt.x + _likeBt.width + 20;
			_dislikeBt.y = _likeBt.y;
		}
		
		
		
		
		
		
		//__________________________________________________________ MOUSE EVENTS
		
		/**
		 * Called when a component is rolled over.
		 */
		private function mouseOverHandler(event:MouseEvent):void {
			var target:Cube = event.target as Cube;
			if(target != null) {
				TweenLite.to(target, .75, {rotationX:90, ease:Bounce.easeOut});
			}
		}

		/**
		 * Called when a component is rolled out.
		 */
		private function mouseOutHandler(event:MouseEvent):void {
			var target:Cube = event.target as Cube;
			if(target != null) {
				TweenLite.to(target, .75, {rotationX:0, ease:Bounce.easeOut});
			}
		}		
	}
}