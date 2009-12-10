package com.valkryie.environment.geometric.statics {
	import com.valkryie.environment.camera.IsoCamera;

	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class IsoStatics extends Object {
		
		public static const GRID_X:int = 0;
		public static const GRID_Y:int = 0;
		public static var 	GRID_WIDTH:int;
		public static var 	GRID_DEPTH:int;
		
		public static var	GRID_CENTER_X:Number;
		public static var	GRID_CENTER_Y:Number;
		
		
		public static var WORLD_OFFSET_X:Number;
		public static var WORLD_OFFSET_Y:Number;
		
		public static var CAMERA_OFFSET_X:Number;
		public static var CAMERA_OFFSET_Y:Number;
		
		public function IsoStatics() {
		}
		
		
		public static function worldToScreen(_isoX:int, _isoY:int, _isoZ:int):Point {
			
			//Need to take into account Camera viewable area offset x and y. (This is usually going to be 0 and 0).
			//Then add in rotation which should merely rotate the x and y around a rotation matrix around the center point of the world.
			
			var pt:Point = new Point(_isoX, _isoY);
			var m:Matrix = IsoCamera.CAMERA_ROTATION_MATRIX;
			
			pt.x -= GRID_CENTER_X;
			pt.y -= GRID_CENTER_Y;
			pt = m.transformPoint(pt);
			pt.x += GRID_CENTER_X;
			pt.y += GRID_CENTER_Y;
			
			
			var sx:Number = pt.x - pt.y + WORLD_OFFSET_X;
			var sy:Number = (pt.x + pt.y)/2 - _isoZ;

			return new Point(sx, sy);
		}
		
		//Incorperate Depth somehow?
		public static function screenToWorld(_sx:int, _sy:int):Point {

			var isoY:Number = _sy - (_sx/2) + (WORLD_OFFSET_X/2); // -_isoZ/2;
			var isoX:Number = _sx + isoY - WORLD_OFFSET_X;
			
			var pt:Point = new Point(isoX, isoY);
			var m:Matrix = IsoCamera.CAMERA_ROTATION_MATRIX.clone();
			m.invert();
			
			pt.x -= GRID_CENTER_X;
			pt.y -= GRID_CENTER_Y;
			pt = m.transformPoint(pt);
			pt.x += GRID_CENTER_X;
			pt.y += GRID_CENTER_Y;
			
			pt.x = Math.round(pt.x);
			pt.y = Math.round(pt.y);
			
			return pt;
		}
	}
}
