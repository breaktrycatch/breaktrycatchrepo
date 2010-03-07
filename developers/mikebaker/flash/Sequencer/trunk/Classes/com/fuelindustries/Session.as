package com.fuelindustries
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * A static class to store variables to be accessed later from anywhere in your project.
	 */
	public class Session extends EventDispatcher
	{
		
		private static var __values:Dictionary;
		
		/**
		 * Sets the value of a property
		 * 
		 * @param prop A string representing the name of the varibale to be stored.
		 * @param val The value of the variable to be stored
		 */
		public static function setValue( prop:String, val:* ):void
		{
			if( __values == null ) __values = new Dictionary( true );
			__values[ prop ] = val;
		}
		
		/**
		 * Gets the value of a property that has been previously stored.
		 * 
		 * @param prop The name of the value that has been stored
		 * @return The variable that was previously stored
		 */ 
		public static function getValue( prop:String ):Object
		{
			return( __values[ prop ] );
		}
	}
	
	
}