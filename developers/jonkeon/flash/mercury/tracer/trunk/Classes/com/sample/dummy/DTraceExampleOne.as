package com.sample.dummy {

	/**
	 * @author jkeon
	 */
	public class DTraceExampleOne extends Object {
		
		public function DTraceExampleOne() {
		}
		
		public function callDTrace():String {
			return dtrace("This is a sample dtrace");
		}
	}
}
