package com.valkryie.data.enum {

	/**
	 * @author jkeon
	 */
	public class EnumeratorVO extends Object {
		
		public var value:*;
		public var identifier:String;
		
		public function EnumeratorVO(_identifier:String, _value:*) {
			identifier = _identifier;
			value = _value;
		}
	}
}
