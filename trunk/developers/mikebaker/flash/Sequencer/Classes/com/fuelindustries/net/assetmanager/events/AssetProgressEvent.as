package com.fuelindustries.net.assetmanager.events {
	import flash.events.Event;
	
	/**
	 * @author Jon
	 */
	public class AssetProgressEvent extends Event {
		
		public static const PROGRESS:String = "asset_progress";
		
		private var __bytesLoaded:int;
		private var __bytesTotal:int;
		private var __group:int;
		
		public function AssetProgressEvent(type : String, _bytesLoaded:int, _bytesTotal:int, _group:int, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__bytesLoaded = _bytesLoaded;
			__bytesTotal = _bytesTotal;
			__group = _group;
		}
		
		public function get bytesLoaded():int {
			return __bytesLoaded;	
		}
		public function get bytesTotal():int {
			return __bytesTotal;	
		}
		public function get group():int {
			return __group;	
		}
	}
}
