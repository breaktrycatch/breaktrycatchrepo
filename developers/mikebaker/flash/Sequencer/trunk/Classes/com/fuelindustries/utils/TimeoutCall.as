package com.fuelindustries.utils
{

	public class TimeoutCall extends IntervalCall
	{
		public function TimeoutCall( id:int, func:Function, interval:int, callbackArgs:Array )
		{
			super( id, func, interval, callbackArgs );
		}
		
		/** @private */
		override internal function execute():void
		{
			super.execute();
			IntervalManager.clearTimeout( __id );
		}
	}
}