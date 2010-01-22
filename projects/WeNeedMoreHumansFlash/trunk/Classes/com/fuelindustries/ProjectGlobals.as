package com.fuelindustries
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * A static class to store variables to be accessed later from anywhere in your project.
	 */
	public class ProjectGlobals extends EventDispatcher
	{
		private static var URLS:Dictionary = new Dictionary();
		private static var FLASHVARS:Dictionary = new Dictionary();
		
		/**
		 * Saves a url to be used throughout your project. Use this method so that you only have your url's set in on place, 
		 * so that if it changes you don't have to change the url in multiple areas
		 * 
		 * @param name A string representing the name of the url to be stored.
		 * @param url The value of the url to be stored
		 * 
		 * @see getURL
		 */
		public static function setURL( name:String, url:String ):void
		{
			URLS[ name ] = url;	
		}
		
		
		/**
		 * Returns a saved url that was previously saved with ProjectGlobals.setURL
		 * 
		 * @param name The name of the url that was saved.
		 * 
		 * @see setURL
		 */
		public static function getURL( name:String ):String
		{
			var url:String = URLS[ name ] as String;
			return( url );
		}
		
		
		/**
		 * Saves a flashvar to be used throughout your project.
		 * 
		 * @param name A string representing the name of the flashvar to be stored.
		 * @param value The value of the flashvar to be stored
		 * 
		 * @see getFlashVar
		 */
		public static function setFlashVar(name:String,value:String):void
		{
		    FLASHVARS[ name ] = value;
		}
		
		/**
		 * Returns a saved flasvar that was previously saved with ProjectGlobals.setFlashVar
		 * 
		 * @param name The name of the flashvar that was saved.
		 * 
		 * @see setFlashVar
		 */
		public static function getFlashVar( name:String ):String
		{
			var flashvar:String = FLASHVARS[ name ] as String;
			return( flashvar );
		}
	}
}