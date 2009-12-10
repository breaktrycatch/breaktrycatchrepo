package com.fuelindustries.controls.listClasses
{
	import com.fuelindustries.controls.buttons.RadioButton;

	/**
	 * @copy com.fuelindustries_assetproxy.controls.listClasses.CellRenderer
     * This renderer provides functionality for selecting the cell. 
     * Used primarily as the renderer in the SelectableList component.
     * 
     * @see ICellRenderer
     * @see ListData
	 */
	public class SelectableCellRenderer extends RadioButton implements ICellRenderer
	{
		protected var __listData:ListData;
		
		/**
         * @copy com.fuelindustries_assetproxy.controls.listClasses.ICellRenderer#data
		 */
		override public function get data():Object
		{
			return( __data ); 	
		}
		
		/** @private */
		override public function set data( val:Object ):void
		{
			setData( val );
		}
		
		/**
         * @copy com.fuelindustries_assetproxy.controls.listClasses.ICellRenderer#listData
		 */
		public function get listData():ListData
		{
			return( __listData );
		}
		
		/** @private */
		public function set listData(obj:ListData):void
		{
			setListData( obj );
		}
		
		public function SelectableCellRenderer()
		{
			maintainClassReference = true;
		}
		
		/**
		 * When extending CellRenderer override this method to set any custom 
		 * properties for that Cell. 
		 * For example, if you had a Leadboard you would set the username, rank, and score values here.
		 */
		protected function setData( obj:Object ):void
		{
			__data = obj;
			setLabel( obj.label );
			if( !enabled )
			{ 
				enabled = true;
				mouseEnabled = true;
			}
			//set all values and ui elements here	
		}
		
		/** @private */
		protected function setListData( obj:ListData ):void
		{
			__listData = obj;
		}
		
		/**
         * @copy com.fuelindustries_assetproxy.controls.listClasses.ICellRenderer#clearData
		 */
		public function clearData():void
		{
			setLabel( "" );
			__data = null;
			__listData = null;
			mouseEnabled = false;
			enabled = false;
			
			if( selected == true )
			{
				selected = false;
			}
		}

	}
}