package com.fuelindustries.events
{
	import flash.events.Event;

	/**
	 * The ZipArchiveEvent class defines events for when a file has been extracted from the a zip archive and is ready to be displayed.
	 * These events include the following:
	 * <ul>
	 * <li><code>ZipArchiveEvent.FILE_COMPLETE</code>: dispatched after the user clicks the mouse over an item in the component.</li>
	 * </ul>
     * @see com.fuelindustries.net.ZipArchive ZipArchive
	 */
	public class ZipArchiveEvent extends Event
	{

		/**
         * Defines the value of the <code>type</code> property of an <code>fileComplete</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is 
		 *          no default behavior to cancel.</td></tr>	
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>content</code></td><td>The content that is ready to be displayed</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType fileComplete
		 */
		public static const FILE_COMPLETE:String = "fileComplete";

		private var __content:Object;
		
		/**
		 * The content that is to be displayed.
		 * Usually a MovieClip or Bitmap
		 */
		public function get content():Object
		{
			return( __content );	
		}
		
		/**
		 * Creates a new ZipArchiveEvent object with the specified parameters. 
		 * Is dispatched when a file has completely loaded from the archive and is ready to be displayed.
         * @param type The event type; this value identifies the action that caused the event.
         * @param content A reference to the displayable content
		 */
		public function ZipArchiveEvent( type:String, content:Object = null )
		{
			__content = content;
			super( type, false, false );
		}
		
		/**
		 * Returns a string that contains all the properties of the ZipArchiveEvent object. The string
		 * is in the following format:
		 * 
		 * <p>[<code>ZipArchiveEvent type=<em>value</em> bubbles=<em>value</em>
		 * 	cancelable=<em>value</em> content=<em>value</em></code>]</p>
		 *
         * @return A string representation of the ZipArchiveEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "ZipArchiveEvent", "type", "content" ) ); 	
		}
		
		/**
		 * Creates a copy of the ZipArchiveEvent object and sets the value of each parameter to match
		 * the original.
		 *
         * @return A new ZipArchiveEvent object with parameter values that match those of the original.
		 */
		override public function clone():Event
		{
			return( new ZipArchiveEvent( type, content ) );	
		}
		
	}
}