package com.adobe.kuler.params
{	
	/**
	 * An object for passing parameters to the search. 
	 * 
	 * @author Josh Chernoff
	 */
	public class SearchParams 
	{		
		public static const THEME_ID:String = "themeID";
		public static const USER_ID:String = "userID";
		public static const EMAIL:String = "email";
		public static const TAG:String = "tag";
		public static const HEX:String = "hex";
		public static const TITLE:String = "title";
			
		private var _type:String;
		private var _value:String;
		
		/**
		 * SearchParams Constructor 
		 */
		public function SearchParams(type:String, value:String = "" ) 
		{
			if (type == null) throw new Error("Wrong type in pram 1 of SearchParams");
			_type = type;
			_value = value;
		}
		
		
		public function toString():String
		{
			return "searchQuery="+_type+":"+_value;
		}
		
	}
	
}