package com.valkryie.data.vo {

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
