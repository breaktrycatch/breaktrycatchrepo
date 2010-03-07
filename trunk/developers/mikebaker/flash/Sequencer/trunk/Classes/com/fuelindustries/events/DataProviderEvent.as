package com.fuelindustries.events
{
	import flash.events.Event;

	/**
	 * The DataProviderEvent class defines data change events for when there is a change is ta DataProvider. 
	 * These events include the following:
	 * <ul>
	 * <li><code>DataProviderEvent.ADD_ITEM</code>: is set to changeType when a single item is added to the DataProvider</li>
	 * <li><code>DataProviderEvent.REMOVE_ITEM</code>: is set to changeType when a single item is removed from the DataProvider.</li>
	 * <li><code>DataProviderEvent.REPLACE_ITEM</code>: is set to changeType when a item is replaced with another in the DataProvider.</li>
	 * <li><code>DataProviderEvent.UPDATE_ALL</code>: is set to changeType when the whole DataProvider is updated.</li>
	 * <li><code>DataProviderEvent.REMOVE_ALL</code>: is set to changeType when all the items are removed from the DataProvider.</li>
	 * <li><code>DataProviderEvent.DATA_CHANGE</code>: dispatched when there is any change in the DataProvider</li>
	 * </ul>
     * @see com.fuelindustries.data.DataProvider DataProvider
	 */
	public class DataProviderEvent extends Event
	{
		/**
		 * Indicates a item has been added to the DataProvider.
		 */
		public static const ADD_ITEM:String = "addItem";
		/**
		 * Indicates a item has been removed to the DataProvider.
		 */
		public static const REMOVE_ITEM:String = "removeItem";
		/**
		 * Indicates a item has been replaced by another item in the DataProvider.
		 */
		public static const REPLACE_ITEM:String = "replaceItem";
		/**
		 * Indicates that the whole DataProvider has been updated.
		 */
		public static const UPDATE_ALL:String = "updateAll";
		/**
		 * Indicates that all items have been removed from the DataProvider.
		 */
		public static const REMOVE_ALL:String = "removeAll";
		
		/**
         * Defines the value of the <code>type</code> property of an <code>dataChange</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>	
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>startIndex</code></td><td>The zero-based start index in the DataProvider
		 * 			where the change has occured</td></tr>
		 * 	  <tr><td><code>endIndex</code></td><td>The zero-based end index in the DataProvider
		 * 			where the change has occured
		 * 	  <tr><td><code>changeType</code></td><td>The type of change that has occured in the DataProvider.</td></tr>
		 *  </table>
         *
		 */
		public static const DATA_CHANGE:String = "dataChange";
		
		private var __changeType:String;
		private var __startIndex:int;
		private var __endIndex:int;
		
		/**
         * Gets a constant value that indicates how the DataProvider has changed during the event. 
		 * <code>DataProviderEvent.ADD_ITEM</code> indicates an item was added to the DataProvider; a value of 
		 * <code>DataProviderEvent.REMOVE_ITEM</code> indicates an item was removed from the DataProvider; a value of 
		 * <code>DataProviderEvent.REPLACE_ITEM</code> indicates an item was replaced by another item in the DataProvider; a value of 
		 * <code>DataProviderEvent.UPDATE_ALL</code> indicates that the DataProvider as been complete set with new data; a value of 
		 * <code>DataProviderEvent.REMOVE_ALL</code> indicates that all items have been removed from the DataProvider.
         * @see com.fuelindustries.controls.ScrollType.ScrollType ScrollType
		 */
		public function get changeType():String
		{
			return( __changeType );	
		}
		
		
		/**
		 * Gets the index of the first changed item in the array of items 
		 * that were changed.
         *
         * @see #endIndex               
		 */
		public function get startIndex():int
		{
			return( __startIndex );	
		}

		/**
         * Gets the index of the last changed item in the array of items
		 * that were changed.
         *
         * @see #startIndex
		 */
		public function get endIndex():int
		{
			return( __endIndex );	
		}
		
		/**
		 * Creates a new DataProviderEvent object with the specified parameters.
		 *
         * @param changeType The changeType 
		 * <code>DataProviderEvent.ADD_ITEM</code> indicates an item was added to the DataProvider; a value of 
		 * <code>DataProviderEvent.REMOVE_ITEM</code> indicates an item was removed from the DataProvider; a value of 
		 * <code>DataProviderEvent.REPLACE_ITEM</code> indicates an item was replaced by another item in the DataProvider; a value of 
		 * <code>DataProviderEvent.UPDATE_ALL</code> indicates that the DataProvider as been complete set with new data; a value of 
		 * <code>DataProviderEvent.REMOVE_ALL</code> indicates that all items have been removed from the DataProvider.
         * @param startIndex The index of the first changed item in the array of items
         * @param endIndex The index of the last changed item in the array of items 
		 */
		public function DataProviderEvent( changeType:String, startIndex:int, endIndex:int )
		{
			__changeType = changeType;
			__startIndex = startIndex;
			__endIndex = endIndex;
			super( DATA_CHANGE, false, false );
		}
		
		/**
		 * Returns a string that contains all the properties of the DataProviderEvent object. The
		 * string is in the following format:
		 * 
		 * <p>[<code>DataProviderEvent type=<em>value</em> changeType=<em>value</em> 
		 * startIndex=<em>value</em> endIndex=<em>value</em>
		 * bubbles=<em>value</em> cancelable=<em>value</em></code>]</p>
		 *
         * @return A string that contains all the properties of the DataProviderEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "DataProivderEvent", "type", "changeType", "startIndex", "endIndex" ) ); 	
		}
		
		/**
		 * Creates a copy of the DataProviderEvent object and sets the value of each parameter to match
		 * that of the original.
		 *
		 * @return A new DataProviderEvent object with property values that match those of the original.
		 */
		override public function clone():Event
		{
			return( new DataProviderEvent( __changeType, __startIndex, __endIndex ) );	
		}
		
	}
}