package com.fuelindustries.events 
{
	import flash.events.Event;

	public class VideoPlayerEvent extends Event {
		public static const FULLSCREEN:String="fullscreen";
		public static const MUTE:String="mute";
		public static const RESUME:String="resume";
		public static const PAUSE:String="pause";
		public static const REWIND:String="rewind";
		
		public static const DRAG:String="drag";
		public static const STOPDRAG:String="stopdrag";
		
		public static const PLAYBACKCOMPLETE:String = "playbackcomplete";
		public static const LOADINGCOMPLETE:String = "loadingcomplete";
	
		
		public function VideoPlayerEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
		}
		
		override public function toString():String {
			return( formatToString( "VideoPlayerEvent", "type" ) ); 	
		}
		
		override public function clone():Event {
			return( new VideoPlayerEvent( type ) );	
		}
	}
}