package com.util
{

	import com.thread.ThreadContainer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @author plemarquand
	 */
	public class IntervalSave
	{
		private var __seconds : int;
		private var __container : ThreadContainer;
		private var __interval : uint;

		public function IntervalSave(_container : ThreadContainer, _seconds : int)
		{
			__container = _container;
			__seconds = _seconds;
		}

		public function start() : void
		{
			__interval = setInterval( capture, __seconds * 1000 );
		}

		private function capture() : void
		{
			__container.takeSnapshot();
			__container.reset();
		}

		public function destroy() : void
		{
			clearInterval( __interval );
		}
	}
}
