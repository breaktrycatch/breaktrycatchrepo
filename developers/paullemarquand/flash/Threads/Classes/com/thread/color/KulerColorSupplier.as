package com.thread.color 
{
	import com.adobe.kuler.KulerSingletonProxy;
	import com.adobe.kuler.events.GetResultEvent;
	import com.adobe.kuler.swatches.swatch.Swatch;	

	/**
	 * @author Paul
	 */
	public class KulerColorSupplier extends GradientColorSupplier
	{
		public function KulerColorSupplier(initialColors : Array = null, stepSpeed : int = 10) 
		{
			KulerSingletonProxy.getInstance().service.addEventListener( GetResultEvent.GET_RESULTS, onResults );
			super( (initialColors == null) ? ([]) : (initialColors), stepSpeed );
		}
		
		private function onResults(event : GetResultEvent) : void
		{
			var sum : Array = new Array();
			var arr : Array = event.results.swatches;
			for (var i : Number = 0; i < arr.length; i++) 
			{
				var swatch : Swatch = arr[i];
				sum = sum.concat(swatch.hexColorArray);
			}
			
			_colors = sum;
			activeColorIndex = 0;
		}
	}
}
