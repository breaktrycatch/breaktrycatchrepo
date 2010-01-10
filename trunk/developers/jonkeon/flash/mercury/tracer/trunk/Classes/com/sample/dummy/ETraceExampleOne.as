package com.sample.dummy {

	/**
	 * @author jkeon
	 */
	public class ETraceExampleOne extends Object {
		
		public function ETraceExampleOne() {
		}
		
		public function callETrace():String {
			var e2:ETraceExampleTwo = new ETraceExampleTwo();
			return e2.nextLevelETrace();
		}
	}
}
