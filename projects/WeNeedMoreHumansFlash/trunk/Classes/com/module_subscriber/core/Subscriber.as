package com.module_subscriber.core {
	import com.module_subscriber.elements.Subscription;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author jkeon
	 */
	public class Subscriber extends Object {
		
		//Holds all the Subscriptions
		private static var __subscriptions:Dictionary = new Dictionary(true);
		
		//Temp Class var for easy typing.
		private static var __activeSubscription:Subscription;
		
		public function Subscriber() {
			
		}
		
		
		public static function subscribe(_type:String, _function:Function):void {
			if (__subscriptions[_type] == null) {
				__subscriptions[_type] = new Subscription(_type);
			}
			__activeSubscription = __subscriptions[_type];
			__activeSubscription.addSubscriber(_function);
		}
		
		public static function unsubscribe(_type:String, _function:Function):void {
			if (__subscriptions[_type] != null) {
				__activeSubscription = __subscriptions[_type];
				__activeSubscription.removeSubscriber(_function);
			}
		}
		
		public static function unsubscribeAll(_type:String):void {
			if (__subscriptions[_type] != null) {
				__activeSubscription = __subscriptions[_type];
				__activeSubscription.removeAllSubscribers();
			}
		}
		
		public static function issue(_event:Event):void {
			__activeSubscription = __subscriptions[_event.type];
			if (__activeSubscription != null) {
				__activeSubscription.issue(_event);
			}
			else {
				trace("[Subscriber::issue] - No Subscription exists " + _event.type);
			}
		}
		
		public static function hasSubscribers(_eventType:String):Boolean {
			if (__subscriptions[_eventType] != null) {
				return true;
			}
			else {
				return false;
			}
		}
	}
}
