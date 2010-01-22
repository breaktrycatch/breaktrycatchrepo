package com.humans.data.statics {
	import Object;
	import String;
	import flash.utils.Dictionary;

	/**
	 * @author jkeon
	 */
	public class ProjectStatics extends Object {
		protected static var __statics:Dictionary = new Dictionary(true);
		
		public function ProjectStatics() {
		}
		
		public static function setStatic(_name:String, _value:*):void {
			__statics[_name] = _value;
		}
		
		public static function getStatic(_name:String):* {
			return __statics[_name];
		}
	}
}
