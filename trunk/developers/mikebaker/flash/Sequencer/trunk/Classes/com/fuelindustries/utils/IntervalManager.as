package com.fuelindustries.utils
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	* IntervalManager works like setInterval but is run on enterFrame to help keep it insync
	*/
	public class IntervalManager extends EventDispatcher
	{
		
		private static var __intervalId:int = 0;
		private static var __timeoutId:int = 0;
		
		private static var __intervals:Dictionary = new Dictionary( true );
		private static var __timeouts:Dictionary = new Dictionary( true );
		
		/**
		* Runs a function at a specified interval (in milliseconds). 
		* @param func The name of the function to execute. Do not include quotation marks or parentheses, 
		* and do not specify parameters of the function to call. For example, use functionName, not functionName() or functionName(param). 
		* @param interval The interval in which the function will be called ( in milliseconds )
		* @param callbackArgs An optional list of arguments that are passed to the closure function. 
	    * @return  int — Unique numeric identifier for the timed process.
	    * @see IntervalManager#clearInterval()
		*/	
		public static function setInterval( func:Function, interval:int, ...callbackArgs:Array ):int
		{
			__intervalId++;
			var intcall:IntervalCall = new IntervalCall( __intervalId, func, interval, callbackArgs );
			__intervals[ __intervalId ] = intcall;
			return( __intervalId );
		}
		
		/**
		* Cancels a specific IntervalManager.setInterval call
		* @param id The id of the process
	    * @see IntervalManager#setInterval()
		*/	
		public static function clearInterval( id:int ):void
		{
			if( id != 0 )
			{
				var intcall:IntervalCall =__intervals[ id ];
				if( intcall != null )
				{
					intcall.cancel( true );
					delete( __intervals[ id ] );
				}
			}
		}
		
		/**
		* Runs a specified function after a specified delay (in milliseconds). 
		* @param func The name of the function to execute. Do not include quotation marks or parentheses, 
		* and do not specify parameters of the function to call. For example, use functionName, not functionName() or functionName(param). 
		* @param interval The interval in which the function will be called ( in milliseconds )
		* @param callbackArgs An optional list of arguments that are passed to the closure function. 
	    * @return  int — Unique numeric identifier for the timed process.
	    * @see IntervalManager#clearTimeout()
		*/	
		public static function setTimeout( func:Function, interval:int, ...callbackArgs:Array ):int
		{
			__timeoutId++;
			var timeCall:TimeoutCall = new TimeoutCall( __timeoutId, func, interval, callbackArgs );
			__timeouts[ __timeoutId ] = timeCall;
			return( __timeoutId );
		}
		
		/**
		* Cancels a specific IntervalManager.setTimeout call
		* @param id The id of the process
	    * @see IntervalManager#setTimeout()
		*/	
		public static function clearTimeout( id:int ):void
		{
			if( id != 0 )
			{
				var timeCall:TimeoutCall =__timeouts[ id ];
				if( timeCall != null )
				{
					timeCall.cancel( true );
					delete( __timeouts[ id ] );
				}
			}
		}
				
		/**
		* Calls a function in a specific amount of frames
		* @param func The name of the function to execute. Do not include quotation marks or parentheses, 
		* and do not specify parameters of the function to call. For example, use functionName, not functionName() or functionName(param). 
		* @param frames The amount of frames to wait before calling the function
		* @param callbackArgs An optional list of arguments that are passed to the closure function. 
	    * @return a reference to the FrameCall Object
	    * @see FrameCall
		*/	
		public static function skipFrames( func:Function, frames:int = 1, ...callbackArgs:Array ):FrameCall
		{
			var framecall:FrameCall = new FrameCall( func, frames, callbackArgs );
			return( framecall );
		}

	}
}