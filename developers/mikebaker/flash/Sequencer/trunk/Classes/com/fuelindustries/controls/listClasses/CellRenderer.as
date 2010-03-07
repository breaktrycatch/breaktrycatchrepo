package com.fuelindustries.controls.listClasses
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.vo.ICellRendererData;

	import flash.text.TextField;

	/**
	 * The CellRenderer class defines methods and properties for  
	 * list-based components to use to manipulate and display custom 
	 * cell content in each of their rows. A customized cell can contain
	 * text, an existing component such as a CheckBox, or any class that 
	 * you create. The list-based components that use this class include 
	 * the List, and ComboBox components.
     *
     * @see ICellRenderer
     * @see ListData
	 */
	public class CellRenderer extends FuelUI implements ICellRenderer
	{
		private var __listData:ListData;
		private var __data:ICellRendererData;
		protected var __label:String;
		public var label_txt:TextField;
		
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
		
		/**
		 * @copy com.fuelindustries_assetproxy.controls.listClasses.ICellRenderer#data
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
		
		public function CellRenderer()
		{
			maintainClassReference = true;
		}
		
		/** @private */
		protected function setLabel( txt:String ):void
		{
			if( txt == null ) txt = "";
			__label = txt;
			if( label_txt != null )
			{
				label_txt.text = txt;
			}
		}
		
		/**
		 * When extending CellRenderer override this method to set any custom 
		 * properties for that Cell. 
		 * For example, if you had a Leadboard you would set the username, rank, and score values here.
		 */
		protected function setData( obj:ICellRendererData ):void
		{
			//trace( "setdata ", __listData.row );
			__data = obj;
			
			if( obj.label != null )
			{
				setLabel( obj.label );
			}
			//set all values and ui elements here	
		}
		
		/** @private */
		protected function setListData( obj:ListData ):void
		{
			__listData = obj;
		}
		
		/**
		 * @copy com.fuelindustries_assetproxy.controls.listClasses.ICellRenderer#clearData()
		 */
		public function clearData():void
		{
			setLabel( "" );
			__data = null;
			__listData = null;	
		}
	}
}