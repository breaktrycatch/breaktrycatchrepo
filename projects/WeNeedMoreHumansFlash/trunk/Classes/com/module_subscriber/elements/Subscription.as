package com.module_subscriber.elements {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class Subscription extends Object {
		
		protected var __type:String;
		protected var __function:Function;
		
		protected var __subscribers:Array;
		protected var __index:int;
		protected var __i:int;
		protected var __len:int;
		
		public function Subscription(_type:String) {
			__type = _type;
			__subscribers = new Array();
		}
		
		public function addSubscriber(_function:Function):void {
			if (__subscribers.indexOf(_function) == -1) {
				__subscribers.push(_function);
			}
		}
		
		public function removeSubscriber(_function:Function):void {
			__index = __subscribers.indexOf(_function);
			if (__index != -1) {
				__subscribers.splice(__index,1);
			}
		}
		
		public function removeAllSubscribers():void {
			for (__i = __len - 1; __i >= 0; __i--) {
				__subscribers.splice(__i, 1);
			}
		}
		
		public function issue(_event:Event):void {
			__len = __subscribers.length;
			for (__i = 0; __i < __len; __i++) {
				__subscribers[__i](_event);
			}
		}
		
		
	}
}
