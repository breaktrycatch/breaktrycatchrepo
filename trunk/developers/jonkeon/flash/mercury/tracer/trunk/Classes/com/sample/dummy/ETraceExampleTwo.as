package com.sample.dummy {

	/**
	 * @author jkeon
	 */
	public class ETraceExampleTwo extends Object {
		
		public function ETraceExampleTwo() {
		}
		
		public function nextLevelETrace():String {
			var e3:ETraceExampleThree = new ETraceExampleThree();
			return e3.finalLevelETrace();
		}
	}
}
