package com.fuelindustries.net.assetmanager.events {
	import flash.events.Event;
	
	/**
	 * @author Jon
	 */
	public class AssetCompleteEvent extends Event {
		
		public static const COMPLETE:String = "asset_complete";
		
		private var __group:int;
		
		public function AssetCompleteEvent(type : String, _group:int, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__group = _group;
		}
		
		public function get group():int {
			return __group;	
		}
	}
}
