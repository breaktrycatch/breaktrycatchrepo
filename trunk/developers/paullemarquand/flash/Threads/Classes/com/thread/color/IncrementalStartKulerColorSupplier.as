package com.thread.color 
{
	import com.thread.color.KulerColorSupplier;

	/**
	{
		private static var _globalCounter : int = 0;
		
		{
		
		override protected function onResults(event : ColorRecievedEvent) : void
		{
			super.onResults( event );
			
			activeColorIndex = _globalCounter;
			_globalCounter++;
		}
	}