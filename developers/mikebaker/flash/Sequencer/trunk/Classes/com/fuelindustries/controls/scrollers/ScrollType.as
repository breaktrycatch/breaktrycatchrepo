package com.fuelindustries.controls.scrollers
{
	/**
	 * There are 2 ways to interact with the scroll bar.
	 * 1. By dragging the scroll thumb up and down.
	 * 2. By clicking or holding down the up and down arrows.
	 * When a scrollbar dispatches a scroll event, the ScrollEvent.scrollType is set to
	 * determine how the user is interacting with the scrollbar.
	 * @see com.fuelindustries_assetproxy.events.ScrollEvent#scrollType
	 */
	public class ScrollType
	{
		/**
		 * Determines that the user is interacting with the up or down arrow
		 */
		public static const LINE:String = "line";
		/**
		 * Determines that the user is interacting with the scroll thumb
		 */
		public static const BAR:String = "bar";
	}
}