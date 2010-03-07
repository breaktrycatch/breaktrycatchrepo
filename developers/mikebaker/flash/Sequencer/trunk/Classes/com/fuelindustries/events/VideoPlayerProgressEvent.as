package com.fuelindustries.events 
{
	import flash.events.Event;

	public class VideoPlayerProgressEvent extends Event {
		public static const UPDATELOCATION:String="updatelocation";
		
		private var __per:Number;
		
		public function VideoPlayerProgressEvent(type:String, _per:Number, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			__per = _per;
		}
		
		public function get percent():Number {
			return __per;	
		}
		
		override public function toString():String {
			return( formatToString( "VideoPlayerEvent", "type" ) ); 	
		}
		
		override public function clone():Event {
			return( new VideoPlayerEvent( type ) );	
		}
	}
}