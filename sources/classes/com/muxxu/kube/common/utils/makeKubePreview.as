package com.muxxu.kube.common.utils {
	import com.muxxu.kube.common.vo.KUBData;
	import com.nurun.utils.math.MathUtils;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @author Francois
	 */
	public function makeKubePreview(data:KUBData, smooth:Boolean = false, sizeCoeff:Number = 1):BitmapData {
			var vertices:Vector.<Number> = Vector.<Number>([
        							//TOP FACE
        							sizeCoeff*19, 0,
        							sizeCoeff*39, sizeCoeff*10,
        							sizeCoeff*19, sizeCoeff*19,
        							0, sizeCoeff*10,
        							//LEFT FACE
        							0, sizeCoeff*10,
        							sizeCoeff*19, sizeCoeff*19,
        							sizeCoeff*19, sizeCoeff*41,
        							0, sizeCoeff*32,
        							//RIGHT FACE
        							sizeCoeff*19, sizeCoeff*19,
        							sizeCoeff*39, sizeCoeff*10,
        							sizeCoeff*39, sizeCoeff*32,
        							sizeCoeff*19, sizeCoeff*41
        							]);

			var UVData:Vector.<Number> = Vector.<Number>([
            						//TOP FACE
									1, 1,
									0, 1,
									0, 0,
									1, 0,
									//LEFT FACE
									1, 0,
									0, 0,
									0, 1,
									1, 1,
									//RIGHT FACE
									1, 1,
									1, 0,
									0, 0,
									0, 1,
									]);

			var indicesTop:Vector.<int> = Vector.<int>([0, 1, 3, 3, 1, 2]);
			var indicesLeft:Vector.<int> = Vector.<int>([4, 5, 6, 6, 7, 4]);
			var indicesRight:Vector.<int> = Vector.<int>([8, 9, 11, 11, 9, 10]);
  
			var top:BitmapData = data.faceTop.clone();
			
			var m:Matrix = new Matrix();
			m.rotate(90 * MathUtils.DEG2RAD);
			m.translate(top.width,0);
			m.scale(1, -1);
			m.translate(0, top.height);
  			
  			var shadow:int = -40;
			var right:BitmapData = data.faceSides.clone();
			right.fillRect(right.rect, 0);
			right.draw(data.faceSides, m);
			right.applyFilter(right, right.rect, new Point(0,0), new ColorMatrixFilter([1,0,0,0,shadow, 0,1,0,0,shadow, 0,0,1,0,shadow, 0,0,0,1,0]));
			
  			shadow = -30;
			var left:BitmapData = data.faceSides.clone();
			left.applyFilter(left, left.rect, new Point(0,0), new ColorMatrixFilter([1,0,0,0,shadow, 0,1,0,0,shadow, 0,0,1,0,shadow, 0,0,0,1,0]));

			var shape:Shape = new Shape();
			
			shape.x = shape.y = 20;
			
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(top, null, false, smooth);
			shape.graphics.drawTriangles(vertices, indicesTop, UVData);
			shape.graphics.beginBitmapFill(left, null, false, smooth);
			shape.graphics.drawTriangles(vertices, indicesLeft, UVData);
			shape.graphics.beginBitmapFill(right, null, false, smooth);
			shape.graphics.drawTriangles(vertices, indicesRight, UVData);
			shape.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData(shape.width, shape.height, true, 0);
			bmd.draw(shape);
			return bmd;
	}
}
