package com.commitmon.view.event
{
	import com.commitmon.model.ProjectVO;
	
	import flash.events.Event;
	
	public class SaveActionEvent extends Event
	{
		public static const SAVE : String = "save";
		public static const CANCEL : String = "cancel";
		
		public var project : ProjectVO;
		
		public function SaveActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}