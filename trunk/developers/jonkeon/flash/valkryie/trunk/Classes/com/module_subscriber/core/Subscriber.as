package com.module_subscriber.core {
	import com.module_subscriber.elements.Subscription;

	import flash.utils.Dictionary;

	/**
	 * @author jkeon
	 */
	public class Subscriber extends Object {
		
		private static var __subscriptions:Dictionary = new Dictionary(true);
		
		private static var __activeSubscription:Subscription;
		
		public function Subscriber() {
			
		}
		
		public static function subscribe(_type:String, _function:Function):void {
			if (__subscriptions[_type] == null) {
				//create new subscription
				__subscriptions[_type] = new Subscription();		
			}
			__activeSubscription = __subscriptions[_type];
			
			
			
		}
	}
}
