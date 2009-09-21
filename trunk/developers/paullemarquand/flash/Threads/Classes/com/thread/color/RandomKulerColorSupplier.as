package com.thread.color 
{	import com.adobe.kuler.events.GetResultEvent;
	import com.thread.color.KulerColorSupplier;
	
	/**	 * @author plemarquand	 */	public class RandomKulerColorSupplier extends KulerColorSupplier 
	{
		
				public function RandomKulerColorSupplier(initialColors : Array = null, stepSpeed : int = 10)
		{			super( initialColors, stepSpeed );		}

		override protected function onResults(event : GetResultEvent) : void
		{
			super.onResults( event );
			
			activeColorIndex = Math.round(Math.random( ) * _colors.length);
		}
	}}