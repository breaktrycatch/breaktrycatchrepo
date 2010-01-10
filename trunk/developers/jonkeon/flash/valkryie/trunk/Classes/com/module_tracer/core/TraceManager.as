package com.module_tracer.core {

	/**
	 * @author jkeon
	 */
	public class TraceManager extends Object {
		
		public static var DEPLOYED_ERROR_TRACE:Boolean = true;
		public static var DEPLOYED_DEBUG_TRACE:Boolean = false;
		public static var DEPLOYED_QUICK_TRACE:Boolean = false;
		
		public static var IDE_ERROR_TRACE:Boolean = true;
		public static var IDE_DEBUG_TRACE:Boolean = true;
		public static var IDE_QUICK_TRACE:Boolean = true;
		
		public static var LIVE_MODE:Boolean = false;
		
		public function TraceManager() {
			
		}
	}
}
