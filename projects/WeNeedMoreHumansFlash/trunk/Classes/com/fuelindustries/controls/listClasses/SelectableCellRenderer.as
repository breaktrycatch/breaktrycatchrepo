package com.fuelindustries.controls.listClasses
{
	import com.fuelindustries.controls.buttons.RadioButton;
	import com.fuelindustries.vo.ICellRendererData;

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
		private var __listData:ListData;
		
		private var __data:ICellRendererData;
		
		/**
		 * @copy com.fuelindustries.controls.listClasses.ICellRenderer#data
		 */
		public function get cellData():ICellRendererData
		{
			return( __data );
		}
		
		/** @private */
		public function set cellData(obj:ICellRendererData):void
		{
			setData( obj );
		}
		
		/**
         * @copy com.fuelindustries.controls.listClasses.ICellRenderer#listData
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
		protected function setData( obj:ICellRendererData ):void
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
			
			if( selected )
			{
				selected = false;
			}
		}

	}
}