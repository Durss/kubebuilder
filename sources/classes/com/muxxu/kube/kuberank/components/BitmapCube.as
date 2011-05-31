package com.muxxu.kube.kuberank.components {
	import com.muxxu.kube.kuberank.vo.CubeData;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	/**
	 * Draws a bitmap cube with drawTriangles API.
	 * 
	 * @author Francois
	 */
	public class BitmapCube extends Sprite {
		
		private var _size:int;
		private var _data:CubeData;
		private var _smooth:Boolean;
		
		
		

		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		/**
		 * Creates an instance of <code>BitmapCube</code>.
		 */
		public function BitmapCube() {
			mouseChildren = false;
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */
		/**
		 * Gets the cube's data.
		 */
		public function get data():CubeData { return _data; }



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Populates the component
		 * 
		 * @param data	data to display.
		 * @param size	sizes of the cube.
		 */
		public function populate(data:CubeData, size:int, smooth:Boolean = false):void {
			_smooth = smooth;
			_data = data;
			_size = size;
			build();
		}
		


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */
		/**
		 * Initialize the class.
		 */
		private function build():void {
			var coeff:Number = _size * 1.35;
			var vertices:Vector.<Number> = Vector.<Number>([
        							//TOP FACE
        							coeff*.5, 0,
        							coeff, coeff*.17,
        							coeff*.5, coeff*.35,
        							0, coeff*.17,
        							//LEFT FACE
        							0, coeff*.17,
        							coeff*.5, coeff*.35,
        							coeff*.5, coeff,
        							0, coeff*.8,
        							//RIGHT FACE
        							coeff*.5, coeff*.35,
        							coeff, coeff*.17,
        							coeff, coeff*.8,
        							coeff*.5, coeff
        							]);

			var UVData:Vector.<Number> = Vector.<Number>([
            						//TOP FACE
									0, 0, 600/(600+100),
									1, 0, 600/(600+50),
									1, 1, 600/(600+0),
									0, 1, 600/(600+50),
									//LEFT FACE
									0, 0, 600/(600+50),
									1, 0, 600/(600+0),
									1, 1, 600/(600+0),
									0, 1, 600/(600+50),
									//RIGHT FACE
									0, 0, 600/(600+0),
									1, 0, 600/(600+50),
									1, 1, 600/(600+50),
									0, 1, 600/(600+0)
									]);

			var indicesTop:Vector.<int> = Vector.<int>([0, 1, 3, 3, 1, 2]);
			var indicesLeft:Vector.<int> = Vector.<int>([4, 5, 6, 6, 7, 4]);
			var indicesRight:Vector.<int> = Vector.<int>([8, 9, 10, 8, 10, 11]);
  
			var top:BitmapData = _data.kub.faceTop.clone();
			top.applyFilter(top, top.rect, new Point(0,0), new ColorMatrixFilter([1,0,0,0,20, 0,1,0,0,20, 0,0,1,0,20, 0,0,0,1,0]));
			
			var left:BitmapData = _data.kub.faceSides.clone();
			left.applyFilter(left, left.rect, new Point(0,0), new ColorMatrixFilter([1,0,0,0,-30, 0,1,0,0,-30, 0,0,1,0,-30, 0,0,0,1,0]));
			
			graphics.clear();
			graphics.beginBitmapFill(top, null, false, _smooth);
			graphics.drawTriangles(vertices, indicesTop, UVData);
			graphics.beginBitmapFill(left, null, false, _smooth);
			graphics.drawTriangles(vertices, indicesLeft, UVData);
			graphics.beginBitmapFill(_data.kub.faceSides, null, false, _smooth);
			graphics.drawTriangles(vertices, indicesRight, UVData);
			graphics.endFill();
		}
		
	}
}