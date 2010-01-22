package com.fuelindustries.vo 
{

	/**
	 * @author julian
	 */
	public class LabelVO implements ICellRendererData 
	{
		private var __label:String;
		
		public function set label( val:String ):void
		{
			__label = val;	
		}
		
		public function get label():String
		{
			return( __label );
		}
		
		public function LabelVO( _label:String = null )
		{
			label = _label;
		}
	}
}
