package com.valkryie.data.vo.geometric {
	import com.valkryie.data.vo.core.AbstractDataVO;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.geom.Point;

	/**
	 * @author Jon
	 */
	public class VertexVO extends AbstractDataVO {
		public function VertexVO() {
			super();
		}
		
		
		public function updateScreenCoordinates():void {
			
			var pt:Point = IsoStatics.worldToScreen(isoX, isoY, isoZ);
			
			transformedX = pt.x;
			transformedY = pt.y;
		}
		
		
		public function get isoX() : int {
			return get("isoX");
		}
		
		public function set isoX(_isoX : int) : void {
			set("isoX", _isoX);
		}
		
		public function get isoY() : int {
			return get("isoY");
		}
		
		public function set isoY(_isoY : int) : void {
			set("isoY", _isoY);
		}
		
		public function get isoZ() : int {
			return get("isoZ");
		}
		
		public function set isoZ(_isoZ : int) : void {
			set("isoZ", _isoZ);
		}
		
		public function get transformedX() : int {
			return get("transformedX");
		}
		
		public function set transformedX(_transformedX : int) : void {
			set("transformedX", _transformedX);
		}
		
		public function get transformedY() : int {
			return get("transformedY");
		}
		
		public function set transformedY(_transformedY : int) : void {
			set("transformedY", _transformedY);
		}
		
		public function get u() : Number {
			return get("u");
		}
		
		public function set u(_u : Number) : void {
			set("u", _u);
		}
		
		public function get v() : Number {
			return get("v");
		}
		
		public function set v(_v: Number) : void {
			set("v", _v);
		}
	}
}
