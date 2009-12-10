package com.fuelindustries.data
{
	import com.fuelindustries.events.DataProviderEvent;

	import flash.events.EventDispatcher;

	/**
	 * Dispatched after the data has changed.
	 * 
     * @eventType com.fuelindustries.events.DataProviderEvent.DATA_CHANGE
     * 
	 */
	[Event(name="dataChange", type="com.fuelindustries.events.DataChangeEvent")]
	
	/**
	 * The DataProvider class provides methods and properties that allow you to query and modify
	 * the data in any list-based component--for example, in a List or ComboBox component.
	 * <p>A <em>data provider</em> is a linear collection of items that serve as a data source--for 
	 * example, an array. Each item in a data provider is an object that contains one or 
	 * more fields of data. You can access the items that are contained in a data provider by index, by 
	 * using the <code>DataProvider.getItemAt()</code> method.</p>
	 */
	public class DataProvider extends EventDispatcher
	{
		private var items:Array;
				
		/**
         * The number of items that the data provider contains.
		 */
		public function get length():int
		{
			return( items.length );	
		}
		
		/**
		 * Creates a new DataProvider object using a list, an array of data objects as the data source. 
		 * 
         * @param dp The data that is used to create the DataProvider.
         * @param dispatchCreate Whether or not to dispatch a <code>DataProviderEvent.UPDATE_ALL</code> event when created.
		 */
		public function DataProvider( dp:Array = null, dispatchCreate:Boolean = false )
		{
			if( dp == null )
			{
				items = [];
			}
			else
			{
				items = dp;
				if( dispatchCreate )
				{
					dispatchChange( DataProviderEvent.UPDATE_ALL, 0, length );	
				}
			}
		}
		
		/**
		 * Appends an item to the end of the data provider and dispatches a <code>DataProviderEvent.ADD_ITEM</code> event.
         * @param item The item to be appended to the end of the current data provider.
         *
         * @see #addItemAt()
         * @see #addItems()
         * @see #addItemsAt()
		 */
		public function addItem( item:Object ):void
		{
			addItemAt( item, length );
		}
		
		/**
		 * Adds a new item to the data provider at the specified index and dispatches a <code>DataProviderEvent.ADD_ITEM</code> event.
		 * If the index that is specified exceeds the length of the data provider,
		 * the index is ignored.
		 * @param item An object that contains the data for the item to be added.
         * @param index  The index at which the item is to be added.
         *
         * @throws RangeError The specified index is less than 0 or greater than or equal 
		 *         to the length of the data provider.
         *
         * @see #addItem()
         * @see #addItems()
         * @see #addItemsAt()
         * @see #getItemAt()
         * @see #removeItemAt()
		 */
		public function addItemAt( item:Object, index:int ):void
		{
			checkIndex( index, items.length );
			items.splice( index, 0, item );
			dispatchChange( DataProviderEvent.ADD_ITEM, index, index + 1 );
		}
		
		/**
		 * Removes the specified item from the data provider and dispatches a <code>DataProviderEvent.REMOVE_ITEM</code> event.
		 * @param item Item to be removed.
         * @return The item that was removed.
         *
         * @see #removeAll()
         * @see #removeItemAt()
		 */
		public function removeItem( item:Object ):void
		{
			var index:int = getItemIndex( item );
			removeItemAt( index );
		}
		
		/**
		 * Removes the item at the specified index and dispatches a <code>DataProviderEvent.REMOVE_ITEM</code>event.
		 * @param index Index of the item to be removed.
         * @return The item that was removed.
         *
         * @throws RangeError The specified index is less than 0 or greater than
         *         or equal to the length of the data provider.
         *
         * @see #removeAll()
         * @see #removeItem()
		 */
		public function removeItemAt( index:int ):void
		{
			checkIndex( index, items.length - 1 );
			items.splice( index, 1 );
			dispatchChange( DataProviderEvent.REMOVE_ITEM, index, index + 1 );
		}
		
		
		/**
		 * Removes all items from the data provider and dispatches a <code>DataProviderEvent.REMOVE_ALL</code> event.
         * @see #removeItem()
         * @see #removeItemAt()
		 */
		public function removeAll():void
		{
			items = [];
			dispatchChange( DataProviderEvent.REMOVE_ALL, 0, 0 );
		}
		
		/**
		 *  Replaces the item at the specified index and dispatches a <code>DataProviderEvent.REPLACE_ITEM</code>event.
		 * @param item The replacement item.
		 * @param index The index of the item to be replaced.
         * 
         * @throws RangeError The specified index is less than 0 or greater than 
         *         or equal to the length of the data provider.
         *
         * @see #replaceItem()
		 */
		public function replaceItemAt( item:Object, index:int ):void
		{
			checkIndex( index, items.length - 1 );
			items.splice( index, 1, item );
			dispatchChange( DataProviderEvent.REPLACE_ITEM, index, index + 1 );
		}
		
		/**
		 * Replaces an existing item with a new item and dispatches a <code>DataProviderEvent.REPLACE_ITEM</code>event.
		 * @param item The replacement item.
		 * @param oldObject The item to be replaced.
         * @throws RangeError The item could not be found in the data provider.
         *
         * @see #replaceItemAt()
		 */
		public function replaceItem( item:Object, oldObject:Object ):void
		{
			var index:int = getItemIndex( oldObject );
			replaceItemAt( item, index );
		}
		
		/**
         * Returns the item at the specified index.
		 * @param index Location of the item to be returned.
		 * @return The item at the specified index.
         *
         * @throws RangeError The specified index is less than 0 or greater than 
		 *         or equal to the length of the data provider.
         *
         * @see #getItemIndex()
         * @see #removeItemAt()
		 */
		public function getItemAt( index:int ):Object
		{
			checkIndex( index, items.length - 1 );
			return( items[ index ] );
		}
		
		/**
         * Returns the index of the specified item.
		 * @param item The item to be located.
         * @return The index of the specified item, or -1 if the specified item is not found.
         * @see #getItemAt()
		 */
		public function getItemIndex( item:Object ):int
		{
			return( items.indexOf( item ) );	
		}
		
		/**
		 * Sets all the items in the DataProvider
		 * @param arr An array of the new data
		 * @param throwEvent Whether or not to dispatch a <code>DataProviderEvent.UPDATE_ALL</code> event.
		 */
		public function setItems( arr:Array, throwEvent:Boolean = false ):void
		{
			items = arr;
			if( throwEvent )
			{
				dispatchChange( DataProviderEvent.UPDATE_ALL, 0, length );
			}
		}
		
		/**
		 * Gets all the items in the DataProvider
		 * @returns An array of the data
		 */
		public function getItems():Array
		{
			return( items );	
		}
		
		/**
		 * Creates a copy of the current DataProvider object.
         * @return A new instance of this DataProvider object.
		 */
		public function clone():DataProvider
		{
			return( new DataProvider( items ) );	
		}
		
		private function dispatchChange( type:String, startIndex:int, endIndex:int ):void
		{
			var e:DataProviderEvent = new DataProviderEvent( type, startIndex, endIndex );
			dispatchEvent( e );
		}

		private function checkIndex( index:int, maximum:int ):void 
		{
			if( index > maximum || index < 0 ) 
			{
				throw new RangeError( "DataProvider index (" + index + ") is not in acceptable range (0 - " + maximum + " )" );
			}
		}
		
	}
}