package com.adobe.kuler.swatches 
{
	import com.adobe.kuler.swatches.swatch.Swatch;
	
	/**
	 * Swatches is the main container for the results of a request. 
	 * @author Josh Chernoff
	 */
	public class Swatches 
	{
		
		private var _swatches:		Array;
		
		private var _startIndex:	int;
		private var _itemsPerPage:	int;
		private var _recordCount:	int;
		private var _title:			String;
		private var _description:	String;
		
		
		public function Swatches(data:XML) 
		{
			var xml:XML		= data;
			_itemsPerPage 	= xml.channel.itemsPerPage;
			_startIndex 	= xml.channel.startIndex;
			_recordCount	= xml.channel.recordCount;
			_title			= xml.channel.title;
			_description	= xml.channel.description;			
			_swatches 		= new Array();
			
			for each(var item:XML in xml.channel.item)
			{
				var  swatch:Swatch = new Swatch(item);
				_swatches.push(swatch);
			}
		}
		/**
		 * contains all the swatches
		 */
		public function get swatches():Array { return _swatches; }
		/**
		 * startIndex repersents the curent index of the first swatch from the swatches container from all of the total available swatches (AKA a page index)
		 */
		public function get startIndex():int { return _startIndex; }
		/**
		 * itemsPerPage repersents the total number of swatches contained in a swatches object (AKA a items per page)
		 */
		public function get itemsPerPage():int { return _itemsPerPage; }
		/**
		 * recordCount repersents total number of all avalible swatches (AKA total itmes that can be viewed)
		 */
		public function get recordCount():int { return _recordCount; }
		/**
		 * A title for the requested collection of swatches
		 */		
		public function get title():String { return _title; }
		/**
		 * A short description of the requested collection of swatches
		 */
		public function get description():String { return _description; }
		
	}
	
}