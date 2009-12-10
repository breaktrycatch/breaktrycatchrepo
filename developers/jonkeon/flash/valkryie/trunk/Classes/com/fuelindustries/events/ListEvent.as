package com.fuelindustries.events
{
	import flash.events.Event;

	/**
	 * The ListEvent class defines events for list-based components including the List, and ComboBox components. 
	 * These events include the following:
	 * <ul>
	 * <li><code>ListEvent.ITEM_CLICK</code>: dispatched after the user clicks the mouse over an item in the component.</li>
	 * <li><code>ListEvent.ITEM_ROLL_OUT</code>: dispatched after the user rolls the mouse pointer out of an item in the component.</li>
	 * <li><code>ListEvent.ITEM_ROLL_OVER</code>: dispatched after the user rolls the mouse pointer over an item in the component.</li>
	 * </ul>
     * @see com.fuelindustries.controls.SelectableList SelectableList
     * @see com.fuelindustries.controls.ScrollableList ScrollableList
     * @see com.fuelindustries.controls.ComboBox ComboBox
	 */
	public class ListEvent extends Event
	{
		/**
         * Defines the value of the <code>type</code> property of an <code>itemClick</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>	
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.
		 * 	  <tr><td><code>rowIndex</code></td><td>The zero-based index of the row that
		 * 	  		contains the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
         *
         * @eventType itemClick
		 */
		public static const ITEM_CLICK:String = "itemClick";
		/**
         * Defines the value of the <code>type</code> property of an <code>itemRollOver</code> 
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
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.</td></tr>
		 * 	  <tr><td><code>rowIndex</code></td><td>The zero-based index of the row that
		 * 	  		contains the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType itemRollOver
		 *
         * @see #ITEM_ROLL_OUT
		 */
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		/**
         * Defines the value of the <code>type</code> property of an  
		 * <code>itemRollOut</code> event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *    <tr>
         *      <th>Property</th>
         *      <th>Value</th>
         *    </tr>
		 *    <tr>
         *      <td><code>bubbles</code></td>
         *      <td><code>false</code></td></tr>
		 *    <tr><td><code>cancelable</code></td><td><code>false</code>; there is
		 *          no default behavior to cancel.</td></tr>	
		 *    <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.</td></tr>
		 * 	  <tr><td><code>rowIndex</code></td><td>The zero-based index of the row that
		 * 	  		contains the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
         *  </table>
         *
         * @eventType itemRollOut
         *
         * @see #ITEM_ROLL_OVER
		 */
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		
		private var __item:Object;
		private var __index:int;
		private var __rowIndex:int;
				
		/**
         * Gets the data that belongs to the current cell renderer.
		 */
		public function get item():Object
		{
			return( __item );	
		}
		
		/**
         * Gets the zero-based index of the cell that contains the renderer.
		 */
		public function get index():int
		{
			return( __index );
		}
		
		/**
		 * Gets the row index of the item that is associated with this event.
		 */
		public function get rowIndex():int
		{
			return( __rowIndex );	
		}
				
		/**
		 * Creates a new ListEvent object with the specified parameters. 
		 * 
         * @param eventType The event type; this value identifies the action that caused the event.
         * @param item A reference to the data that belongs to the renderer. 
         * @param index The zero-based index of the item in the DataProvider. 
         * @param rowIndex The zero-based index of the row that contains the renderer or visual
		 *        representation of the data in the row. 
		 */
		public function ListEvent( eventType:String, item:Object, index:int, rowIndex:int )
		{
			__item = item;
			__index = index;
			__rowIndex = rowIndex;
			super( eventType, false, false );
		}
		
		/**
		 * Returns a string that contains all the properties of the ListEvent object. The string
		 * is in the following format:
		 * 
		 * <p>[<code>ListEvent type=<em>value</em> bubbles=<em>value</em>
		 * 	cancelable=<em>value</em> rowIndex=<em>value</em>
		 * 	index=<em>value</em> item=<em>value</em></code>]</p>
		 *
         * @return A string representation of the ListEvent object.
		 */
		override public function toString():String
		{
			return( formatToString( "ListEvent", "type", "item", "index", "rowIndex" ) ); 	
		}
		
		/**
		 * Creates a copy of the ListEvent object and sets the value of each parameter to match
		 * the original.
		 *
         * @return A new ListEvent object with parameter values that match those of the original.
		 */
		override public function clone():Event
		{
			return( new ListEvent( type, item, index, rowIndex ) );	
		}
		
	}
}