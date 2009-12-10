package com.valkryie.data.enum {

	/**
	 * @author jkeon
	 */
	public class Enum extends Object {
		
		protected var __values:Array;
		
		protected var __selectedValue:int;
		
		
		public function Enum() {
			__values = [];
		}
		
		public function addEnum(_identifier:String, _value:*):void {
			var e:EnumeratorVO = new EnumeratorVO(_identifier, _value);
			__values.push(e);	
		}
		
		public function resolveToValue(_identifier:String):* {
			var e:EnumeratorVO;
			for (var b in __values) {
				e = __values[b] as EnumeratorVO;
				if (e.identifier == _identifier) {
					return e.value;
				}
			}
			return null;
		}
		
		public function resolveToIdentifier(_value:String):String {
			var e:EnumeratorVO;
			for (var b in __values) {
				e = __values[b] as EnumeratorVO;
				if (e.value == _value) {
					return e.identifier;
				}
			}
			return null;
		}
		
		public function validate(_challenge:*):* {
			var e:EnumeratorVO;
			for (var b in __values) {
				e = __values[b] as EnumeratorVO;
				if (e.value == _challenge) {
					return _challenge;
				}
			}
			return (__values[0] as EnumeratorVO).value;
		}
		
		public function getNextAfter(_identifier:String):int {
			var e:EnumeratorVO;
			var index:int;
			search: for (var i:int = 0; i < __values.length; i++) {
				e = __values[i] as EnumeratorVO;
				if (e.identifier == _identifier) {
					index = i;
					break search;
				}
			}
			
			//Wrap
			var candidate:int = index + 1;
			if (candidate >= __values.length) {
				candidate = 0;
			}
			
			e = __values[candidate];
			return e.value;
		}
		
		public function getPrevBefore(_identifier:String):int {
			var e:EnumeratorVO;
			var index:int;
			search: for (var i:int = 0; i < __values.length; i++) {
				e = __values[i] as EnumeratorVO;
				if (e.identifier == _identifier) {
					index = i;
					break search;
				}
			}
			
			//Wrap
			var candidate:int = index - 1;
			if (candidate < 0) {
				candidate = __values.length - 1;
			}
			
			e = __values[candidate];
			return e.value;
		}
		
		public function get values() : Array {
			return __values;
		}
	
	}
}
