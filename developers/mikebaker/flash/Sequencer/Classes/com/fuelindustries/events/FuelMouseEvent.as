package com.fuelindustries.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * The FuelMouseEvent class defines events for SimpleButton.press
	 * These events include the following:
	 * <ul>
	 * <li><code>FuelMouseEvent.PRESS</code>: dispatched when the user press down on a SimpleButton</li>
	 * </ul>
     * @see com.fuelindustries_assetproxy.controls.buttons.SimpleButton SimpleButton
	 */
	public class FuelMouseEvent extends MouseEvent
	{
		/**
         * Defines the value of the <code>type</code> property of an <code>press</code> 
		 * event object.
         *
         * @eventType press
		 */
		public static const PRESS:String = "press";
		public static const RELEASE_OUTSIDE:String = "releaseOutside";
		
		public function FuelMouseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=0, localY:Number=0, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0.0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
		/**
		 * Returns a string that contains all the properties of the ListEvent object. The string
		 * is in the following format:
		 * 
		 * <p>[<code>FuelMouseEvent type=<em>value</em> localX=<em>value</em>
		 * 	localY=<em>value</em> relatedObject=<em>value</em></code>]</p>
		 *
         * @return A string representation of the FuelMouseEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "FuelMouseEvent", "type", "localX", "localY", "relatedObject" ) ); 	
		}
		
		/**
		 * Creates a copy of the FuelMouseEvent object and sets the value of each parameter to match
		 * the original.
		 *
         * @return A new FuelMouseEvent object with parameter values that match those of the original.
		 */
		override public function clone():Event
		{
			return( new FuelMouseEvent( type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta ) );	
		}
		
	}
}