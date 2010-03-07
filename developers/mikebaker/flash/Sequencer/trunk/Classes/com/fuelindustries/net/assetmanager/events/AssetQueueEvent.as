package com.fuelindustries.net.assetmanager.events {
	import flash.events.Event;
	
	/**
	 * @author Jon
	 */
	public class AssetQueueEvent extends Event {
		
		public static const COMPLETE:String = "queue_complete";
		
		private var __queueName:String;
		
		public function AssetQueueEvent(type : String, _queueName:String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__queueName = _queueName;
		}
		
		public function get queueName():String {
			return __queueName;	
		}
	}
}
