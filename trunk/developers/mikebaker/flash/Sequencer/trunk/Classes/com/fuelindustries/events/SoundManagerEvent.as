package com.fuelindustries.events 
{
	import flash.events.Event;

	/**
	 * @author jslater
	 */
	public class SoundManagerEvent extends Event 
	{
		public static const MUTE:String = "mute";
		public static const SOUND_STARTED:String = "soundStarted";
		public static const SOUND_COMPLETE:String = "soundComplete";
		public static const SOUND_STOPPED:String = "soundStopped";
		
		public function SoundManagerEvent(type:String)
		{
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new SoundManagerEvent( type );
		}
	}
}
