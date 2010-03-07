package com.fuelindustries.events
{
	import flash.events.Event;

	/**
	 * The GenericEvent class is a base event class that you can add properties to the args property so you can pass variables around quickly.
	 */
	public class GenericEvent extends Event
	{
		
		private var __args:Object;
		
		/**
         * Gets the args object.
		 */
		public function get args():Object
		{
			return( __args );	
		}
		
		/**
		 * Creates a new GenericEvent object with the specified parameters. 
		 * 
         * @param type The event type; this value identifies the action that caused the event.
         * @param args A object that can contain any properties to be passed to the listeners.
		 */
		public function GenericEvent( type:String, args:Object )
		{
			__args = args;
			super( type, false, false );	
		}
		
		/**
         * Retruns the specified variable from the args Object
         * @param prop A String that represents the variable to be passed back
         * @return Object
		 */
		public function getArg( prop:String ):Object
		{
			return( __args[ prop ] );	
		}
		
		/**
		 * Returns a string that contains all the properties of the GenericEvent object. The string
		 * is in the following format:
		 * 
		 * <p>[<code>GenericEvent type=<em>value</em> bubbles=<em>value</em>
		 * 	cancelable=<em>value</em></code>]</p>
		 *
         * @return A string representation of the GenericEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "GenericEvent", "type" ) ); 	
		}
		
		/**
		 * Creates a copy of the GenericEvent object and sets the value of each parameter to 
		 * match the original.
		 *
         * @return A new GenericEvent object with parameter values that match the original.
		 */
		override public function clone():Event
		{
			return( new GenericEvent( type, __args ) );	
		}
	}
}