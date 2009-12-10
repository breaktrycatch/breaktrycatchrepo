package com.fuelindustries.controls.listClasses
{
	/**
     * The ICellRenderer interface provides the methods and properties that a cell renderer requires.
	 * All user defined cell renderers should implement this interface.
	 * 
     * @see com.fuelindustries_assetproxy.controls.listClasses.CellRenderer CellRenderer
     * 
	 */	
	public interface ICellRenderer
	{
		/**
         * Gets or sets an Object that represents the data that is 
		 * associated with a component. When this value is set, the 
		 * component data is stored and the containing component is 
		 * invalidated. The invalidated component is then automatically 
		 * redrawn.
		 *
		 * <p>The data property represents an object containing the item
		 * in the DataProvider that the cell represents.  Typically, the
		 * data property contains standard properties, depending on the
		 * component type. The data property can also contain user-specified
		 * data relevant to the specific cell. Users can extend a CellRenderer
		 * for a component to utilize different properties of the data 
		 * in the rendering of the cell.</p>
		 */
		function get data():Object
		
		/**
		* @private
		*/
		function set data( obj:Object ):void
		
		
		/**
         * Gets or sets the list properties that are applied to the cell--for example,
		 * the <code>index</code> and <code>selected</code> values. These list properties
		 * are automatically updated after the cell is invalidated.
		 * @see ListData
		 */
		function get listData():ListData
		
		/**
		* @private
		*/
		function set listData( obj:ListData ):void
		
		/**
		 * Clears all of the data from CellRenderer. This method is called when the list
		 * is cleared or the list is being invalidated.
		 */
		function clearData():void
	}
}