package com.humans.utils.events {
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class BitmapLoadedEvent extends Event {
		
		public static const BITMAP_LOADED:String = "bitmap_loaded";
		
		protected var __bitmapData:BitmapData;
		
		public function BitmapLoadedEvent(type : String, _bitmapData:BitmapData, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__bitmapData = _bitmapData;
		}
		
		public function get bitmapData() : BitmapData {
			return __bitmapData;
		}
	}
}
