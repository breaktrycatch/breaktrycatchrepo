package com.fuelindustries.events
{
	import flash.events.Event;

	/**
	 * The ScrollEvent class defines the scroll event that is associated with the ScrollBar component.
	 * 
	 * @see com.fuelindustries.controls.scrollers.ScrollBar ScrollBar
	 * @see com.fuelindustries.controls.scrollers.ScrollBarDirection ScrollBarDirection
	 */
	public class ScrollEvent extends Event
	{
		/**
         * Defines the value of the <code>type</code> property of a <code>scroll</code>
		 * event object.
		 *
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is no default
		 * 			behavior to cancel.</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 * 			the event object with an event listener.</td></tr>
		 *     <tr><td><code>percent</code></td><td><code>0</code>; the position in percent of the
		 * 			Scrollbar thumb after it was moved. </td></tr>
		 * 	   <tr><td><code>scrollType</code></td><td><code>0</code>; The type of scrollbar interaction. </td></tr>
		 *		<tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
		 * 
         * @eventType scroll
		 */
		public static const SCROLL:String = "scroll";
		
		private var __scrollType:String;
		private var __percent:Number;
		
		/**
         * Gets the current scroll position, in percent, 0-1.
		 */
		public function get percent():Number
		{
			return( __percent );	
		}
		
		/**
         * Gets a constant value that indicates how the scrollbar is being interacted with associated during the event. 
		 * <code>ScrollType.LINE</code> indicates scrollbar is scrolling by arrow buttons; a value of 
		 * <code>ScrollType.BAR</code> indicates scrolling by dragging the scrollthumb.
         * @see com.fuelindustries.controls.ScrollType.ScrollType ScrollType
		 */
		public function get scrollType():String
		{
			return( __scrollType );	
		}
		
		/**
		 * Creates a new ScrollEvent object with the specified parameters.
		 *
         * @param scrollType The scrollType 
		 * <code>ScrollType.LINE</code> indicates scrollbar is scrolling by arrow buttons; a value of 
		 * <code>ScrollType.BAR</code> indicates scrolling by dragging the scrollthumb.
         * @param percent The current scroll position in percent - a value between 0-1.
		 */
		public function ScrollEvent( scrollType:String, percent:Number )
		{
			__percent = percent;
			__scrollType = scrollType;
			super( SCROLL, false, false );
		}
		
		/**
		 * Returns a string that contains all the properties of the ScrollEvent object. The
		 * string has the following format:
		 * 
		 * <p>[<code>ScrollEvent type=<em>value</em> bubbles=<em>value</em>
		 * cancelable=<em>value</em> scrollType=<em>value</em>
		 * percent=<em>value</em></code>]</p>
		 *
         * @return A string representation of the ScrollEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "ScrollEvent", "type", "percent", "scrollType" ) ); 	
		}
		
		/**
		 * Creates a copy of the ScrollEvent object and sets the value of each parameter to 
		 * match the original.
		 *
         * @return A new ScrollEvent object with parameter values that match the original.
		 */
		override public function clone():Event
		{
			return( new ScrollEvent( __scrollType, __percent ) );	
		}
		
	}
}