package com.thread.color
{

	import com.adobe.kuler.events.ColorRecievedEvent;
	import com.thread.color.KulerColorSupplier;

	/**	 * @author plemarquand	 */
	public class RandomKulerColorSupplier extends KulerColorSupplier
	{
		public function RandomKulerColorSupplier(initialColors : Array = null, stepSpeed : int = 10)
		{
			super( initialColors, stepSpeed );
		}

		override protected function onResults(event : ColorRecievedEvent) : void
		{
			super.onResults( event );

			activeColorIndex = Math.round( Math.random() * _colors.length );
		}
	}
}