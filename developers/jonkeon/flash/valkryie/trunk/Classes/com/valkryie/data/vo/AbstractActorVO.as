package com.valkryie.data.vo {

	/**
	 * @author jkeon
	 */
	public class AbstractActorVO extends AbstractDataVO {
		public function AbstractActorVO() {
			super();
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

		
	}
}
