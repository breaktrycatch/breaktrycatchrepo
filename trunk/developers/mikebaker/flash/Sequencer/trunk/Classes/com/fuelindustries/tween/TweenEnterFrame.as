package com.fuelindustries.tween
{
	import flash.display.MovieClip;
	import flash.events.*;

	public class TweenEnterFrame
	{
		/** @private */
		public static var mc:MovieClip;
		
		/** @private */
		private static function init():void
		{
			if( !exists() )
			{
				mc = new MovieClip();
			}
		}
		
		/** 
		 * Checks to see if the EnterFrame is already running
		 * @return Wether the EnterFrame is running
		 */
		private static function exists():Boolean
		{
			var val:Boolean = ( mc == null ) ? false : true;
			return( val );
		}
		
		/** 
		 * Registers a listener to listen to the enterFrame Event
		 * @param func The listener function that will process the event
		 * @param weakReference Always use default value of true
		 */
		public static function addListener( func:Function, weakReference:Boolean = true ):void
		{
			if( !exists() )
			{
				init();
			}
			mc.addEventListener( Event.ENTER_FRAME, func, false, 0, weakReference );
		}
		
		/** 
		 * Removes the listener from the enterFrame Event
		 * @param func The listener function to remove from listening to the event
		 */
		public static function removeListener( func:Function ):void
		{
			if( !exists() )
			{
				init();
			}
			
			mc.removeEventListener( Event.ENTER_FRAME, func );
		}
	}
}