package com.commitmon.controller.event
{
	import flash.events.Event;
	
	public class NotificationProcessEvent extends Event
	{
		public static const REFRESH_STARTED : String = "refreshStarted";
		public static const REFRESH_COMPLETE : String = "refreshComplete";
		
		public function NotificationProcessEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}