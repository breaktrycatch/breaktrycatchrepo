package com.thread.color 
{
	import com.adobe.kuler.KulerSingletonProxy;
	import com.adobe.kuler.events.ColorRecievedEvent;
	import com.adobe.kuler.events.GetResultEvent;
	import com.thread.vo.IDisposable;

	/**
	 * @author Paul
	 */
	public class KulerColorSupplier extends GradientColorSupplier implements IDisposable
	{
		public function KulerColorSupplier(initialColors : Array = null, stepSpeed : int = 10) 
		{
			KulerSingletonProxy.getInstance().addEventListener( ColorRecievedEvent.COLORS_RECIEVED, onResults );
			KulerSingletonProxy.getInstance().getRandomColours();
			
			super( (initialColors == null) ? ([]) : (initialColors), stepSpeed );
		}
		
		protected function onResults(event : ColorRecievedEvent) : void
		{
			KulerSingletonProxy.getInstance().removeEventListener( ColorRecievedEvent.COLORS_RECIEVED, onResults );
			
			_colors = event.colors;
			activeColorIndex = 0;
		}

		public function dispose() : void
		{
			KulerSingletonProxy.getInstance().service.removeEventListener( GetResultEvent.GET_RESULTS, onResults );
		}
	}
}
