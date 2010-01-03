package com.valkryie.data.vo.actor {
	import com.valkryie.data.vo.core.AbstractDataVO;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class AbstractActorVO extends AbstractDataVO {
		
		protected var __isoBounds:Rectangle;	
		
		public function AbstractActorVO() {
			super();
			
			__isoBounds = new Rectangle();
		}
		
		public function get isoX() : int {
			return get("isoX");
		}
		
		public function set isoX(_isoX : int) : void {
			set("isoX", _isoX);
			__isoBounds.x = _isoX;
		}
		
		public function get isoY() : int {
			return get("isoY");
		}
		
		public function set isoY(_isoY : int) : void {
			set("isoY", _isoY);
			__isoBounds.y = _isoY;
		}
		
		public function get isoZ() : int {
			return get("isoZ");
		}
		
		public function set isoZ(_isoZ : int) : void {
			set("isoZ", _isoZ);
		}
		
		public function get isoWidth() : int {
			return get("isoWidth");
		}
		
		public function set isoWidth(_isoWidth : int) : void {
			if (_isoWidth < 1) {
				_isoWidth = 1;
			}
			else if ((isoX + isoWidth) > IsoStatics.GRID_WIDTH) {
				_isoWidth = IsoStatics.GRID_WIDTH - isoX;
			}
			set("isoWidth", _isoWidth);
			__isoBounds.width = _isoWidth;
		}
		
		public function get isoDepth() : int {
			return get("isoDepth");
		}
		
		public function set isoDepth(_isoDepth : int) : void {
			
			if (_isoDepth < 1) {
				_isoDepth = 1;
			}
			else if ((isoY + _isoDepth) > IsoStatics.GRID_DEPTH) {
				_isoDepth = IsoStatics.GRID_DEPTH - isoY;
			}
			set("isoDepth", _isoDepth);
			__isoBounds.height = _isoDepth;
		}
		
		public function get isoBounds():Rectangle {
			return __isoBounds;
		}
	}
}
