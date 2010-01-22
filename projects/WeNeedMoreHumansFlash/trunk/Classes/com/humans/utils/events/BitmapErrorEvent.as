package com.humans.utils.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class BitmapErrorEvent extends Event {
		
		public static const BITMAP_URL_WAS_NOT_SET:String = "bitmap_url_was_not_set";
		
		public function BitmapErrorEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
