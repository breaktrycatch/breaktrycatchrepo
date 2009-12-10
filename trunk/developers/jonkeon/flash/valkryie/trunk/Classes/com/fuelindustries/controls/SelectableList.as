package com.fuelindustries.controls {
	import com.fuelindustries.controls.buttons.RadioButtonGroup;
	import com.fuelindustries.controls.listClasses.ICellRenderer;
	import com.fuelindustries.controls.listClasses.ListData;
	import com.fuelindustries.controls.listClasses.SelectableCellRenderer;
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.data.DataProvider;
	import com.fuelindustries.events.DataProviderEvent;
	import com.fuelindustries.events.ListEvent;

	import flash.events.*;

	/**
	 * Dispatched when the user clicks an item in the component.
	 * 
	 * @eventType com.fuelindustries_assetproxy.events.ListEvent.ITEM_CLICK
	 * 
	 */
	[Event(name="itemClick", type="com.fuelindustries_assetproxy.events.ListEvent")]
	
	/**
	 * Dispatched when the user rolls over an item in the component. 
	 * 
	 * @eventType com.fuelindustries_assetproxy.events.ListEvent.ITEM_ROLL_OVER
	 * 
	 */
	[Event(name="itemRollOver", type="com.fuelindustries_assetproxy.events.ListEvent")]
	
	/**
	 * Dispatched when the user rolls out of an item in the component.
	 * 
	 * @eventType com.fuelindustries_assetproxy.events.ListEvent.ITEM_ROLL_OUT
	 * 
	 */
	[Event(name="itemRollOut", type="com.fuelindustries_assetproxy.events.ListEvent")]
	
	public class SelectableList extends BaseList
	{		
		
		/** @private */
		protected var __selectedIndex:int;
		/** @private */
		protected var __selectedItem:Object;
		/** @private */
		protected var __selectedRow:ICellRenderer;
		
		protected var __groupname:String;
		
		/**
		 * Gets or sets the index of the item that is selected in a single-selection list. 
		 * A single-selection list is a list in which only one item can be selected at a time. 
		 * A value of -1 indicates that no item is selected;
		 * When ActionScript is used to set this property, 
		 * the item at the specified index replaces the current selection. 
		 * When the selection is changed programmatically, a change event object is not dispatched. 
		 * 
		 * @throw RangeError selectedIndex is out of range
		 * 
		 */
		public function get selectedIndex():int
		{
			return( __selectedIndex );	
		}
		
		/** @private */
		public function set selectedIndex( index:int ):void
		{
			setSelectedIndex( index );
		}

		/**
		 * Gets or sets the item that was selected from a single-selection list.
		 * 
		 * @default null
		 * 
		 */
		public function SelectableList( cellRenderer:Class = null )
		{	
			super( cellRenderer );
			__selectedIndex = -1;
			__groupname = "listgroup" + RadioButtonGroup.getUniqueID();
		}
		
		/** @private */
		public function get selectedItem():Object
		{
			return( __selectedItem );	
		}
		
		/**
		 * Initializing the CellRenderers to listen for Button Events
		 * @see com.fuelindustries_assetproxy.events.ListEvent.ITEM_CLICK ListEvent.ITEM_CLICK
		 * @see com.fuelindustries_assetproxy.events.ListEvent.ITEM_ROLL_OVER ListEvent.ITEM_ROLL_OVER
		 * @see com.fuelindustries_assetproxy.events.ListEvent.ITEM_ROLL_OUT ListEvent.ITEM_ROLL_OUT
		 */
		override protected function initializeCellRenderer( renderer:ICellRenderer ):void
		{
			super.initializeCellRenderer( renderer );
			var row:SelectableCellRenderer = renderer as SelectableCellRenderer;
			row.addEventListener( MouseEvent.CLICK, rowClick );
			row.addEventListener( MouseEvent.ROLL_OVER, rowOver );
			row.addEventListener( MouseEvent.ROLL_OUT, rowOut );
			
			row.groupname = __groupname;
		}
		
		/** @private */
		protected function rowClick( event:MouseEvent ):void
		{
			var row:SelectableCellRenderer = event.target[AssetProxy.PROXYCODE] as SelectableCellRenderer;
						
			var listData:ListData = row.listData;
			var rowIndex:int = listData.row;
			var index:int = listData.index;
			
			__selectedIndex = index;
			__selectedItem = row.data;
			__selectedRow = row;
			
			dispatchEvent( new ListEvent( ListEvent.ITEM_CLICK, row.data, index, rowIndex ) );
		}
		
		/** @private */
		protected function rowOver( event:MouseEvent ):void
		{
			var row:SelectableCellRenderer = event.target[AssetProxy.PROXYCODE] as SelectableCellRenderer;			
			var listData:ListData = row.listData;
			var rowIndex:int = listData.row;
			var index:int = listData.index;
			dispatchEvent( new ListEvent( ListEvent.ITEM_ROLL_OVER, row.data, index, rowIndex ) );
		}
		
		/** @private */
		protected function rowOut( event:MouseEvent ):void
		{
			var row:SelectableCellRenderer = event.target[AssetProxy.PROXYCODE] as SelectableCellRenderer;
			var listData:ListData = row.listData;
			if (listData != null) {
				var rowIndex:int = listData.row;
				var index:int = listData.index;
				dispatchEvent( new ListEvent( ListEvent.ITEM_ROLL_OUT, row.data, index, rowIndex ) );
			}
		}
		
		/** @inheritDoc */
		override protected function setRow( item:Object, index:int, rowindex:int ):void
		{
			super.setRow( item, index, rowindex );
			var row:SelectableCellRenderer = __rows[ rowindex ] as SelectableCellRenderer;
	
			if( index == __selectedIndex )
			{
				doLater( delaySelection, row );	
			}

		}
		
		private function delaySelection( row:SelectableCellRenderer ):void
		{
			row.selected = true;
		}
		
		/** @private */
		protected function setSelectedIndex( index:int ):void
		{
			if( index >= __dataProvider.length ) {
				index = 0;
				//throw( new RangeError( "selectedIndex is out of range" ) );
			}

			__selectedIndex = index;
			__selectedItem = null;
			
			if( __selectedRow != null )
			{
				var row:SelectableCellRenderer = __selectedRow as SelectableCellRenderer;
				var listData:ListData = row.listData;
				
				if (listData != null) {
					if( listData.index != index )
					{
						row.selected = false;
						setSelectedRow();
					}
				}
			}
			else
			{
				setSelectedRow();	
			}
		}
		
		/** @private */
		protected function setSelectedRow():void
		{
			for( var i:int=0; i<__rowCount; i++ )
			{
				var row:SelectableCellRenderer = __rows[ i ] as SelectableCellRenderer;
				if( row.listData.index == __selectedIndex )
				{
					row.selected = true;
					__selectedItem = row.data;
					return;	
				}	
			}	
		}
	}
}