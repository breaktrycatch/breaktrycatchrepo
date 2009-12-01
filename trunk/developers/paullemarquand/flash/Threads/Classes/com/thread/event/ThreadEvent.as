package com.thread.event 
{
	import flash.events.Event;

	/**
	 * @author Paul
	 */
	public class ThreadEvent extends Event 
	{
		public static const THREAD_DIED : String = "threadDied";
		
		public function ThreadEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
