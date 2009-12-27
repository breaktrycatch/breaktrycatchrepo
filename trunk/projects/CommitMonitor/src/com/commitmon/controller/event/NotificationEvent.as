package com.commitmon.controller.event
{
	import com.commitmon.model.ProjectVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class NotificationEvent extends Event
	{
		public static const REFRESH : String = "refresh";
		public static const REVISIONS_RECIEVED : String = "revisionsRecieved";
		
		public var revisions : ArrayCollection;
		public var project : ProjectVO;
		
		public function NotificationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}