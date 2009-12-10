package com.module_keyinput.elements {

	/**
	 * @author jkeon
	 */
	public class KeyFunction extends Object {
		
		protected var __function:Function;
		protected var __keycode:int;
		protected var __params:Array;
		
		protected var __spamable:Boolean;
		protected var __firecondition:int;
		
		public static const KEY_PRESS:int = 1;
		public static const KEY_RELEASE:int = -1;
		public static const KEY_BOTH:int = 0;
		
		public function KeyFunction(_keycode:int, _function:Function, _params:Array = null, _spamable:Boolean = false, _firecondition:int = KEY_PRESS) {
			__keycode = _keycode;
			__function = _function;
			__params = _params;
			__spamable = _spamable;
			__firecondition = _firecondition;
		}
		
		public function get spamable():Boolean {
			return __spamable;
		}
		
		public function get firecondition():int {
			return __firecondition;
		}
		
		public function clean():void {
			__function = null;
			__params = null;
		}
		
		//Fire's the function
		public function fire():void {
			if (__params != null) {
				switch(__params.length) {
					case 1:
						__function(__params[0]);
					break;
					case 2:
						__function(__params[0], __params[1]);
					break;
					case 3:
						__function(__params[0], __params[1], __params[2]);
					break;
					case 4:
						__function(__params[0], __params[1], __params[2], __params[3]);
					break;
					case 5:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4]);
					break;
					case 6:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4], __params[5]);
					break;
					case 7:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4], __params[5], __params[6]);
					break;
					case 8:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4], __params[5], __params[6], __params[7]);
					break;
					case 9:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4], __params[5], __params[6], __params[7], __params[8]);
					break;
					case 10:
						__function(__params[0], __params[1], __params[2], __params[3], __params[4], __params[5], __params[6], __params[7], __params[8], __params[9]);
					break;
					
					default:
						throw new Error("[KEYFUNCTION] - If you're trying to call a function with more than 10, modify the fire function in KeyFunction");
					break;
				}
				
			}
			else {
				__function();
			}
		}
		
	}
}
