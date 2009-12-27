package com.commitmon.view.event
{
	import com.commitmon.model.ProjectVO;
	
	import flash.events.Event;
	
	public class ProjectListEvent extends Event
	{
		public static const EDIT_ITEM : String = "editItem";
		public static const DELETE_ITEM : String = "deleteItem";
		public static const VIEW_ITEM : String = "viewItem";
		
		public var selectedProject : ProjectVO;
		
		public function ProjectListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}