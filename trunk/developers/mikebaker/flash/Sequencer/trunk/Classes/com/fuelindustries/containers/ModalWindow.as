package com.fuelindustries.containers
{
	import com.fuelindustries.core.FuelUI;

	/**
	 * When linked to a MovieClip it blocks all mouse events from every object underneath in the depth or layer.
	 * Use this when having to disable large portions of the screen when using popups.
	 */
	public class ModalWindow extends FuelUI
	{
		public function ModalWindow()
		{
			super();
			buttonMode = false;
			mouseChildren = false;
			mouseEnabled = true;
		}
	}
}