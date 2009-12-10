package com.valkryie.environment.geometric.component {
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class IsoVertex extends Object {
		
		protected var __isoX:int;
		protected var __isoY:int;
		protected var __isoZ:int;
		
		protected var __transformedX:Number;
		protected var __transformedY:Number;
		
		protected var __u:Number;
		protected var __v:Number;
		
		public function IsoVertex(_isoX:int = 0, _isoY:int = 0, _isoZ:int = 0) {
			__isoX = _isoX;
			__isoY = _isoY;
			__isoZ = _isoZ;
			
			__u = 0;
			__v = 0;
			
			__transformedX = 0;
			__transformedY = 0;	
		}
		
		public function updateScreenCoordinates():void {
			
			var pt:Point = IsoStatics.worldToScreen(__isoX, __isoY, __isoZ);
			
			__transformedX = pt.x;
			__transformedY = pt.y;
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
		
		public function get transformedX() : Number {
			return __transformedX;
		}
		
		public function get transformedY() : Number {
			return __transformedY;
		}
		
		public function get u() : Number {
			return __u;
		}
		
		public function set u(_u : Number) : void {
			__u = _u;
		}
		
		public function get v() : Number {
			return __v;
		}
		
		public function set v(_v : Number) : void {
			__v = _v;
		}
		
		public function toString():String {
			return ("[Vertex] isoX: " + isoX + " isoY: " + isoY + " isoZ: " + isoZ + " transformedX: " + transformedX + " transformedY: " + transformedY + " u: " + u + " v: " + v);
		}
	}
}
