package com.commitmon.view
{
	import spark.components.NavigatorContent;
	
	public class AbstractNavigatorContent extends NavigatorContent
	{
		protected var _data : Object;
		
		public function AbstractNavigatorContent()
		{
			super();
		}
		
		public function set data(obj:Object):void
		{
			_data = obj;
			setData(obj);
		}
		
		protected function setData(obj:Object):void
		{
			
		}
	}
}