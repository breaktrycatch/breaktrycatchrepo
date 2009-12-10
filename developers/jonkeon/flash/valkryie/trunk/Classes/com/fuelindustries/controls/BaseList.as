package com.fuelindustries.controls
{	import com.fuelindustries.controls.listClasses.CellRenderer;
	import com.fuelindustries.controls.listClasses.ICellRenderer;
	import com.fuelindustries.controls.listClasses.ListData;
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.data.DataProvider;
	import com.fuelindustries.events.DataProviderEvent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	/**
	 * A very basic list where no selection or scrolling is required.
	 * Perfect for Leaderboards where you only show 10 items at a time
	 */
	public class BaseList extends FuelUI
	{
		/** @private */
		protected var __rows : Array;
		/** @private */
		protected var __rowCount : int;
		/** @private */
		protected var __startIndex : int;
		/** @private */
		protected var __dataProvider : DataProvider;
		//The Cell Renderer Type
		protected var __cellRendererType : Class;

		//Pass In the cell Renderer.
		public function set cellRendererType(_class : Class) : void 
		{
			__cellRendererType = _class;
		}

		/**
		 * Gets or sets the data model of the list of items to be viewed. 
		 * 
		 * @default null
		 * 
		 * @see com.fuelindustries_assetproxy.data.DataProvider DataProvider
		 * 
		 */
		public function get dataProvider() : Array
		{
			return( __dataProvider.getItems() );	
		}

		/** @private */
		public function set dataProvider( dp : Array ) : void
		{
			setDataProvider(dp);
		}

		/**
		 * Gets the number of rows that are at least partially visible in the list.
		 * This get value gets set automatically by searching through all of the children 
		 * in the List and looking for any MovieClips with the instance name row#_mc
		 * 
		 * @default 0
		 * 
		 */
		public function get rowCount() : int
		{
			return( __rowCount );	
		}

		public function BaseList( cellRenderer:Class = null )
		{
			__cellRendererType = cellRenderer;
		}

		override protected function completeConstruction() : void
		{
			super.completeConstruction();
			init();
		}

		/** @private */
		protected function init() : void
		{
			__startIndex = 0;
			createRows();
		}

		protected function createRows() : void
		{
			if(__cellRendererType == null)
			{
				throw new IllegalOperationError("cellRendererType must be set before the list is initialized!");
			}
			
			var len : int = this.numChildren;
			__rows = [];
			var i : int;

			for( i = 0;i < len; i++ )
			{
				var mc : DisplayObject = this.getChildAt(i);
				var instancename : String = mc.name;
				if( instancename != null )
				{
					var re : RegExp = /row\d+/;
					var test : Boolean = re.test(instancename);
					if( test )
					{
						//Original
						var d : RegExp = /\d+/;
						var index : int = int(instancename.match(d));
                                          
						//Create new AssetProxy of Type
						var cr : AssetProxy = new __cellRendererType();
						
						//Set display by Type
						cr.setDisplayByClip(MovieClip(mc));
						__rows[ index ] = cr;
						initializeCellRenderer(cr as ICellRenderer);
					}
				}
			}
			
			__rowCount = __rows.length;
		}

		/**
		 * This method is used to set any properites or add listeners to the CellRenderers when first initialized.
		 * Override this method when extending this class.
		 * 
		 * @param renderer The ICellRenderer instance to be initialized
		 * 
		 * @see com.fuelindustries_assetproxy.controls.listClasses.CellRenderer CellRenderer
		 * 
		 */
		protected function initializeCellRenderer( renderer : ICellRenderer ) : void
		{
			//do any intializing of renderers here.
			renderer.clearData();
		}

		/** @private */
		protected function setDataProvider( dp : Array ) : void
		{
			if( __dataProvider != null )
			{
				__dataProvider.removeEventListener(DataProviderEvent.DATA_CHANGE, dataChange, false);	
			}
			
			__dataProvider = new DataProvider(dp);
			__dataProvider.addEventListener(DataProviderEvent.DATA_CHANGE, dataChange, false, 0, true);
			__startIndex = 0;
			invalidateList();
		}

		/** @private */
		protected function dataChange( event : DataProviderEvent ) : void
		{
			var type : String = event.changeType;
			var index : int = event.startIndex;
			
			switch( type )
			{
				case DataProviderEvent.UPDATE_ALL:
					invalidateList();
					break;
				case DataProviderEvent.ADD_ITEM:
				case DataProviderEvent.REMOVE_ITEM:
					if( index >= __startIndex && index < ( __startIndex + __rowCount ) )
					{
						invalidateList(index);	
					} 
					break;
				case DataProviderEvent.REPLACE_ITEM:
					if( index >= __startIndex && index < ( __startIndex + __rowCount ) )
					{
						var rowindex : int = getRowIndexAt(index);
						var row : ICellRenderer = __rows[ rowindex ] as ICellRenderer;
						row.data = __dataProvider.getItemAt(index);
					} 
					break;
				case DataProviderEvent.REMOVE_ALL:
					clearList();
					break;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Clears all the CellRenderers properties to their default values
		 * 
		 */
		protected function clearList() : void
		{
			for( var i : int = 0;i < __rowCount; i++ )
			{
				var row : ICellRenderer = __rows[ i ] as ICellRenderer;
				row.clearData();	
			}	
		}

		/**
		 * Resets all of the CellRenderers properties and updates their UI.
		 * Only the CellRenderers that are visible will be updated.
		 * 
		 */
		protected function invalidateList( startIndex : int = 0 ) : void
		{
			for( var i : int = startIndex; i < __rowCount; i++ )
			{
				var row : ICellRenderer = __rows[ i ] as ICellRenderer;
				row.clearData();
				var index : int = __startIndex + i;
			
				if( i < __dataProvider.length )
				{
					var item : Object = __dataProvider.getItemAt(index);
					setRow(item, index, i);
				}
			}			
		}

		/**
		 * Sets the properties of a specific CellRenderer based on the dataProvider
		 * 
		 * @param item The data object from the dataProvider to be set to the CellRenderer.data property
		 * @param index The index of the data in the dataProvider
		 * @param rowindex The index of the CellRenderer
		 * 
		 * @see com.fuelindustries_assetproxy.controls.listClasses.ListData ListData
		 * @see com.fuelindustries_assetproxy.controls.listClasses.CellRenderer CellRenderer
		 * 
		 */
		protected function setRow( item : Object, index : int, rowindex : int ) : void
		{
			var row : ICellRenderer = __rows[ rowindex ] as ICellRenderer;
			if( item != null )
			{
				row.listData = new ListData(this, index, rowindex, 0);
				row.data = item;
			}
		}

		/**
		 * Returns the rowindex at the specified dataProvider index.
		 * If the index doesn't exists in any of the CellRenderers a RangeError is thrown
		 * 
		 * @param index The data index
		 * 
		 * @return The rowindex where the data index is set. 
		 * 
		 * @throws RangeError index doesn't exist in rows
		 * 
		 */
		protected function getRowIndexAt( index : int ) : int
		{
			for( var i : int = 0;i < __rowCount; i++ )
			{
				var row : ICellRenderer = __rows[ i ] as ICellRenderer;
				if( row.listData.index == index )
				{
					return( i );
				}
			}	
			
			throw new RangeError("index doesn't exist in rows");
		}

		/**
		 * Returns the CellRenderer at the specified dataProvider index.
		 * If the index doesn't exists in any of the CellRenderers a RangeError is thrown
		 * 
		 * @param index The data index
		 * 
		 * @return The CellRenderer where the data index is set. 
		 * 
		 * @throws RangeError index doesn't exist in rows
		 * 
		 */
		public function getRowWithIndex( index : int ) : ICellRenderer
		{
			var rowindex : int = getRowIndexAt(index);
			return( __rows[ rowindex ] as ICellRenderer );	
		}

		/**
		 * Returns the CellRenderer at the specified row index
		 * If the index doesn't exists in any of the CellRenderers a RangeError is thrown
		 * 
		 * @param index The data index
		 * 
		 * @return The CellRenderer where the data index is set. 
		 * 
		 * @throws RangeError index doesn't exist in rows
		 * 
		 */
		public function getRowAtIndex( index : int ) : ICellRenderer
		{
			if( index < __rowCount )
			{
				return( __rows[ index ] as ICellRenderer );
			}
			else
			{
				throw new RangeError("row index doesn't exist. Index must be between 0 and " + ( __rowCount - 1 ));
			}
		}

		/**
		 * Removes all of the items from the list
		 * 
		 */
		public function removeAll() : void
		{
			if( __dataProvider != null ) __dataProvider.removeAll();	
		}

		/**
		 * Adds the item to the end of the data model
		 * 
		 * @param item The object to add
		 * 
		 */
		public function addItem( item : Object ) : void
		{
			if( __dataProvider != null ) __dataProvider.addItem(item);
		}

		/**
		 * Adds the item at the specified index
		 * 
		 * @param item The object to add
		 * @param index The index where the object is to be added
		 * 
		 */
		public function addItemAt( item : Object, index : int ) : void
		{
			if( __dataProvider != null ) __dataProvider.addItemAt(item, index);	
		}

		/**
		 * Removes the item at the specified index
		 * 
		 * @param index The index where the object is to be removed
		 * 
		 */
		public function removeItemAt( index : int ) : void
		{
			if( __dataProvider != null ) __dataProvider.removeItemAt(index);	
		}

		/**
		 * Replaces the item at the specified index
		 * 
		 * @param item The object to be added
		 * @param index The index where the object is to be replaced
		 * 
		 */
		public function replaceItemAt( item : Object, index : int ) : void
		{
			if( __dataProvider != null ) __dataProvider.replaceItemAt(item, index);	
		}

		/**
		 * Returns the object in the dataProvider at the specified index
		 * 
		 * @param index The index of the object to be returned
		 * 
		 * @return The object at the index specified
		 * 
		 */
		public function getItemAt( index : int ) : Object
		{
			return( __dataProvider.getItemAt(index) );	
		}
	}
}