package com.fuelindustries.utils
{
	import com.fuelindustries.tween.TweenEnterFrame;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	* Calls a function in a set number of frames 
	* Created to execute a function call when using IntervalManager.skipFrames
	* You should never use this directly and use IntervalManager.skipFrames
	*/
	
	public class FrameCall extends EventDispatcher
	{
		private var __frames:int;
		private var __callback:Function;
		private var __currentframe:int;
		private var __callbackArgs:Array;
		
		public function FrameCall( func:Function, frames:int, callbackArgs:Array )
		{
			__callback = func;
			__frames = frames;
			__callbackArgs = callbackArgs;
			__currentframe = 0;
			TweenEnterFrame.addListener( onEnterFrame, false );
		}
		
		private function onEnterFrame( event:Event ):void
		{
			__currentframe++;
			if( __currentframe == __frames )
			{
				__callback.apply( null, __callbackArgs );
				cancel();
			}
		}
		
		/**
		* Cancels the the function call if it hasn't been exectued
		*/
		public function cancel():void
		{
			TweenEnterFrame.removeListener( onEnterFrame );
			delete( this );
		}
	}
}