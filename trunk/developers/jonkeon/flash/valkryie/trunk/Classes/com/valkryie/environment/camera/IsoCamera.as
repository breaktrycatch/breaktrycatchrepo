package com.valkryie.environment.camera {
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class IsoCamera extends Object {
		
		protected var __isoX:int;
		protected var __isoY:int;
		protected var __isoZ:int;
		
		protected var __screenCenterPoint:Point;
		
		protected static var __location:int;
		
		public static const LOC_NORTH:int = 2;
		public static const LOC_EAST:int = 3;
		public static const LOC_SOUTH:int = 0;
		public static const LOC_WEST:int = 1;
		
		public static var CAMERA_ROTATION_MATRIX:Matrix = new Matrix();
		public static var CAMERA_ROTATION_MATRIX_INVERSE:Matrix = new Matrix();
		
		protected var __focusScreenX:Number;
		protected var __focusScreenY:Number;
		
		protected var __viewableArea:Rectangle;
		
		
		
		public function IsoCamera(_isoX:int = 0, _isoY:int = 0, _isoZ:int = 0) {
			__isoX = _isoX;
			__isoY = _isoY;
			__isoZ = _isoZ;
			location = IsoCamera.LOC_SOUTH;
		}
		
		public function calculateScreenCenter():void {
			
			__focusScreenX = __viewableArea.x + (__viewableArea.width/2);
			__focusScreenY = __viewableArea.y + (__viewableArea.height/2);
			
			__screenCenterPoint = IsoStatics.worldToScreen(__isoX, __isoY, 0);
			
			__screenCenterPoint.x = __focusScreenX - __screenCenterPoint.x;
			__screenCenterPoint.y = __focusScreenY - __screenCenterPoint.y;
			
		}
		
		public function get isoX() : int {
			return __isoX;
		}
		
		public function set isoX(_isoX : int) : void {
			__isoX = _isoX;
		}
		
		
		public function get isoY() : int {
			return __isoY;
		}
		
		public function set isoY(_isoY : int) : void {
			__isoY = _isoY;
		}
		
		public function get isoZ() : int {
			return __isoZ;
		}
		
		public function set isoZ(_isoZ : int) : void {
			__isoZ = _isoZ;
		}
		
		public static function get location() : int {
			return __location;
		}
		
		public static function set location(_location : int) : void {
			__location = _location;
			if (__location < LOC_SOUTH) {
				__location = LOC_EAST;
			}
			else if (__location > LOC_EAST) {
				__location = LOC_SOUTH;
			}
			CAMERA_ROTATION_MATRIX.identity();
			CAMERA_ROTATION_MATRIX.rotate(_location * (Math.PI/2));
			CAMERA_ROTATION_MATRIX_INVERSE = CAMERA_ROTATION_MATRIX.clone();
			CAMERA_ROTATION_MATRIX_INVERSE.invert();
		}
		
		public function setViewableArea(_viewableArea : Rectangle):void {
			__viewableArea = _viewableArea;
			IsoStatics.CAMERA_OFFSET_X = __viewableArea.x;
			IsoStatics.CAMERA_OFFSET_Y = __viewableArea.y;
			calculateScreenCenter();
		}
		
		public function get viewableArea() : Rectangle {
			return __viewableArea;
		}
		
		public function get screenCenterPoint() : Point {
			return __screenCenterPoint;
		}
		
		public function get focusScreenX() : Number {
			return __focusScreenX;
		}
		
		public function get focusScreenY() : Number {
			return __focusScreenY;
		}
	}
}
