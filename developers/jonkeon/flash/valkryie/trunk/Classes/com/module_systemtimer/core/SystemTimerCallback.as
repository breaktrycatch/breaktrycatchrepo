package com.module_systemtimer.core {

	/**
	 * @author jkeon
	 */
	public class SystemTimerCallback extends Object {
		
		protected var __function:Function;
		protected var __trigger:int;
		
		public function SystemTimerCallback(_function:Function, _trigger:int) {
			
			__function = _function;
			__trigger = _trigger;
			
		}
		
		public function get trigger():int {
			return __trigger;	
		}
		
		public function fire(_timeElapsed:int):void {
			__function(_timeElapsed);	
		}
		
		
	}
}
