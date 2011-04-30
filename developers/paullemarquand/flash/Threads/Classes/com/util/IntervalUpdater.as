package com.util
{
	/**
	 * @author plemarquand
	 */
	public class IntervalUpdater
	{
		private var __ctr : uint;
		private var __frequency : uint;
		private var __callback : Function;
		private var __callbackArgs : Array;

		public function IntervalUpdater(_frequency : uint, _callback : Function, ..._callbackArgs)
		{
			__frequency = _frequency;
			__callback = _callback;
			__callbackArgs = _callbackArgs;
		}

		public function update() : void
		{
			__ctr++;
			if (__ctr % __frequency == 0)
			{
				__ctr = 0;
				__callback.apply( undefined, __callbackArgs );
			}
		}
		
		public function get progress() : Number
		{
			return __ctr / __frequency;	
		}
	}
}
