package com.valkryie.environment.geometric.vector {

	/**
	 * @author jkeon
	 */
	public class Iso3DVector extends Object {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Iso3DVector(_x:Number = 0, _y:Number = 0, _z:Number = 0) {
			x = _x;
			y = _y;
			z = _z;
		}
		
		public static function crossProduct(_v1:Iso3DVector, _v2:Iso3DVector, _useFirstPassedVector:Boolean = false):Iso3DVector {
			var result:Iso3DVector = (_useFirstPassedVector == false) ? new Iso3DVector() : _v1;
			
			result.x = (_v2.y * _v1.z) - (_v2.z * _v1.y);
			result.y = (_v2.z * _v1.x) - (_v2.x * _v1.z);
			result.z = (_v2.x * _v1.y) - (_v2.y * _v1.x);
			
			return result;
		}
		
		public static function multiplyScalar(_v:Iso3DVector, _value:Number, _useFirstPassedVector:Boolean = false):Iso3DVector {
			var result:Iso3DVector = (_useFirstPassedVector == false) ? new Iso3DVector() : _v;
			result.x *= _value;
			result.y *= _value;
			result.z *= _value;
			
			return result;
		}
		
		public static function length(_v:Iso3DVector):Number {
			var result:Number = Math.sqrt(_v.x*_v.x + _v.y*_v.y + _v.z*_v.z);
			return result;
		}
		
		public static function normalize(_v:Iso3DVector, _useFirstPassedVector:Boolean = false):Iso3DVector {
			var result:Iso3DVector = (_useFirstPassedVector == false) ? new Iso3DVector() : _v;
			var length:Number = length(result);
			
			result.x /= length;
			result.y /= length;
			result.z /= length;
			
			return result;
		}
		
		public function toString():String {
			return ("[Vector 3D] x: " + x + " y: " + y + " z: " + z);
		}
	}
}
