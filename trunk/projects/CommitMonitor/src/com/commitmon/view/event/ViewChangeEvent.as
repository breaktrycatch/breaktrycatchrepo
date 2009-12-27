package com.commitmon.view.event
{
	import flash.events.Event;
	
	public class ViewChangeEvent extends Event
	{
		
		public static const PROJECT_DETAILS : int = 0;
		public static const COMMIT_DETAILS : int = 1;
		public static const PROJECT_LIST : int = 2;
		//public static const SETTINGS : int = 
		
		public static const CHANGE_VIEW : String = "changeView";
		
		public var selectedView : int = -1;
		public var data : Object;
		
		public function ViewChangeEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var evt : ViewChangeEvent = new ViewChangeEvent(type, bubbles, cancelable);
			evt.selectedView = selectedView;
			evt.data = data;
			return evt;
		}
	}
}