package com.fuelindustries.controls.listClasses
{
	import com.fuelindustries.core.FuelUI;

	/**
	 * ListData is a messenger class that holds information relevant to a specific 
     * cell in a list-based component. This information includes the position of 
	 * the cell in the list by row and column and then index of the data in the DataProvider.
	 *
	 * <p>A new ListData component is created for a cell renderer 
	 * each time it is invalidated.</p>
	 */
	public class ListData extends Object
	{
		
		private var __owner:FuelUI;
		private var __index:int;
		private var __row:int;
		private var __col:int;
		
		
		/**
         * A reference to the List object that owns this item.
		 */
		public function get owner():FuelUI
		{
			return( __owner );	
		}
		
		/**
         * The index of the item in the data provider.
		 */
		public function get index():int 
		{
			return( __index );	
		}
		
		/**
         * The row in which the data item is displayed.
		 */
		public function get row():int
		{
			return( __row );	
		}
		
		
		/**
		 * The column in which the data item is displayed. In a list, 
         * this value is always 0.
		 */
		public function get col():int
		{
			return( __col );	
		}
		
		/**
		 * Creates a new instance of the ListData class as specified by its parameters. 
         * @param owner The component that owns this cell.
         * @param index The index of the item in the data provider.
         * @param row The row in which this item is being displayed. In a List this value corresponds to the index. 
         * @param col The column in which this item is being displayed. In a List, this value is always 0.
		 */	
		public function ListData( owner:FuelUI, index:int, row:int, col:int = 0 )
		{
			__owner = owner;
			__index = index;
			__row = row;
			__col = col;
		}
	}
}