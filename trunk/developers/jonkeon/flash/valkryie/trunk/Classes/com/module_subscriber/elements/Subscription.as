package com.module_subscriber.elements {

	/**
	 * @author jkeon
	 */
	public class Subscription extends Object {
		
		protected var __type:String;
		protected var __function:Function;
		
		protected var __subscribers:Array;
		
		public function Subscription(_type:String) {
			__type = _type;
			__subscribers = new Array();
		}
		
		public function addSubscriber(_function:Function):void {
			if (__subscribers.indexOf(_function) == -1)
		}
		
		
	}
}
