package com.valkryie.data.vo {
	import com.valkryie.environment.geometric.statics.IsoStatics;

	/**
	 * @author jkeon
	 */
	public class AbstractBrushVO extends AbstractActorVO {
		
		
		public function AbstractBrushVO() {
			super();
		}

		
		override public function set isoX(_isoX : int) : void {
			if (_isoX < 0) {
				_isoX = 0;
			}
			super.isoX = _isoX;
		}

		override public function set isoY(_isoY : int) : void {
			if (_isoY < 0) {
				_isoY = 0;
			}
			super.isoY = _isoY;
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
		}
		
		
		public function get subDivisionsX() : int {
			return get("subDivisionsX");
		}
		
		public function set subDivisionsX(_subDivisionsX : int) : void {
			if (_subDivisionsX < 1) {
				_subDivisionsX = 1;
			}
			set("subDivisionsX", _subDivisionsX);
		}
		
		public function get subDivisionsY() : int {
			return get("subDivisionsY");
		}
		
		public function set subDivisionsY(_subDivisionsY : int) : void {
			if (_subDivisionsY < 1) {
				_subDivisionsY = 1;
			}
			set("subDivisionsY", _subDivisionsY);
		}
		
	}
}
