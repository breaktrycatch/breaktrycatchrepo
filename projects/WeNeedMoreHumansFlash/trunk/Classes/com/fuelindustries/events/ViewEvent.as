package com.fuelindustries.events
{
	import flash.events.Event;

	public class ViewEvent extends Event
	{
		public static const OUT_COMPLETE:String="outComplete";
		public static const CHANGE:String="changeSection";
		public static const REMOVE:String ="removeSection";
		
		private var __section:String;
		private var __initObject:Object;
		
		public function get section():String
		{
			return( __section );	
		}
		
		public function get initObject():Object
		{
			return( __initObject );	
		}
		
		public function ViewEvent( type:String, asection:String = null, initObject:Object = null )
		{
			__section = asection;
			__initObject = initObject;
			super( type, true, true );
		}
		
		override public function toString():String
		{
			return( formatToString( "ViewEvent", "type", "section", "initObject" ) ); 	
		}
		
		override public function clone():Event
		{
			return( new ViewEvent( type, section, initObject ) );	
		}
	}
}