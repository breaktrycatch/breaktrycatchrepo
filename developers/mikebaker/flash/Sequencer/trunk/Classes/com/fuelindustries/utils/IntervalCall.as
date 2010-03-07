package com.fuelindustries.utils
{
	import com.fuelindustries.tween.TweenEnterFrame;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	* Returned as the last parameter to a function called from IntervalManager.setInterval
	*/
	
	public class IntervalCall extends EventDispatcher
	{
		private var __startTime:int;
		private var __interval:int;
		private var __callback:Function;
		private var __timesExecuted:int;
		/** @private */
		internal var __id:int;
		private var __timediff:int;
		private var __callbackArgs:Array;
		
		/**
		* The unique id of the interval process
		*/
		public function get id():int
		{
			return( __id );
		}
		
		/**
		* The number of times the interval has been executed
		*/
		public function get timesExecuted():int
		{
			return( __timesExecuted );
		}
		
		/**
		* The difference in milliseconds between when the function should have really been executed and when it actually did
		*/
		public function get timeDiff():int
		{
			return( __timediff );
		}
		
		public function IntervalCall( id:int, func:Function, interval:int, callbackArgs:Array )
		{
			__callback = func;
			__interval = interval;
			__id = id;
			__callbackArgs = callbackArgs;
			__callbackArgs.push( this );
			__timesExecuted = 0;
			
			TweenEnterFrame.addListener( onEnterFrame );
		}
		
		private function onEnterFrame( event:Event ):void
		{
			if( __startTime == 0 )
			{
				__startTime = getTimer();
				return;
			}
					
			var currenttime:int = getTimer() - __startTime;
			
			if( currenttime >= __interval )
			{
				__startTime = getTimer();
				__timediff = currenttime - __interval;
				execute();
			}
		}
		
		/** @private */
		internal function execute():void
		{
			__timesExecuted++;
			__callback.apply( null, __callbackArgs );
		}
		
		/**
		* Cancels the interval
		*/
		public function cancel( fromManager:Boolean = false ):void
		{
			if( !fromManager )
			{
				IntervalManager.clearInterval( __id );
			}
			else
			{
				TweenEnterFrame.removeListener( onEnterFrame );
			}
		}
	}
}