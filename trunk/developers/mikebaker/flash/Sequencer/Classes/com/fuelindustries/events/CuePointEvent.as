package com.fuelindustries.events 
{
	import com.fuelindustries.vo.CuePointVO;

	import flash.events.Event;

	/**
	 * CuePointEvent for the com.fuelindustries.media.CuePointManager class
	 */
	public class CuePointEvent extends Event 
	{
		public static const CUEPOINT:String = "onCuePoint";
		
		private var __data:CuePointVO;
		
		public function get data():CuePointVO
		{
			return( __data );	
		}


		public function CuePointEvent( p_data:CuePointVO ) 
		{
			super( CUEPOINT );
			__data = p_data;
		}

		override public function clone():Event
		{
			return new CuePointEvent( __data );
		}
	}
}
