package com.adobe.kuler.swatches.swatch 
{
	import Namespace;
	import com.adobe.kuler.swatches.swatch.color.Color;
	/**
	 * ...
	 * @author ...
	 */
	public class Swatch 
	{
		private var _colors:Array;
		
		private var _title:String;
		private var _link:String;
		private var _pubDate:Date;
		private var _themeID:int;
		private var _themeTitle:String;
		private var _themeImage:String;
		private var _authorID:String;
		private var _authorLabel:String;
		private var _themeRating:int;
		private var _themeDownloadCount:int;
		private var _themeCreatedAt:int;
		private var _themeEditedAt:int;
		private var _themeTags:Array;
		
		public function Swatch(data:XML) 
		{
			_colors					= new Array();
			var xml:XML 			= data;
			var kuler:Namespace 	= new Namespace(xml.namespace("kuler"));

			_link					= xml.link;			
			_pubDate				= new Date(xml.pubDate);
			
			var tempTheme:XMLList 	= xml.kuler::themeItem;			
			_themeID 				= tempTheme.kuler::themeID;
			_title					= tempTheme.kuler::themeTitle;
			_themeImage				= tempTheme.kuler::themeImage;
			_authorID				= tempTheme.kuler::themeAuthor.kuler::authorID;
			_authorLabel			= tempTheme.kuler::themeAuthor.kuler::authorLabel;
			
			_themeRating			= tempTheme.kuler::themeRating;
			_themeDownloadCount		= tempTheme.kuler::themeDownloadCount;
			_themeCreatedAt			= tempTheme.kuler::themeCreatedAt;
			_themeEditedAt			= tempTheme.kuler::themeEditedAt;
			
			
			//_themeTags = String(xml.kuler::themeItem.kuler::themeTags).slice
			
			var tempSwatch:XMLList = xml.kuler::themeItem.kuler::themeSwatches.kuler::swatch;
			for each(var swatch:XML in tempSwatch)
			{
				var color:Color = new Color(swatch);
				_colors.push(color);
			}
		}
		
		public function get hexColorArray() : Array
		{
			var arr : Array = new Array();
			var len : int = _colors.length;
			for (var i : Number = 0; i < len; i++) 
			{
				arr.push(parseInt(Color(_colors[i]).toString()));	
			}
			return arr;
		}
		
		public function get colors():Array { return _colors; }		
		
		public function get title():String { return _title; }
		
		public function get link():String { return _link; }
		
		public function get pubDate():Date { return _pubDate; }
		
		public function get themeID():int { return _themeID; }
		
		public function get themeTitle():String { return _themeTitle; }
		
		public function get themeImage():String { return _themeImage; }
		
		public function get authorID():String { return _authorID; }
		
		public function get authorLabel():String { return _authorLabel; }
		
		public function get themeRating():int { return _themeRating; }
		
		public function get themeDownloadCount():int { return _themeDownloadCount; }
		
		public function get themeCreatedAt():int { return _themeCreatedAt; }
		
		public function get themeEditedAt():int { return _themeEditedAt; }
		
		public function get themeTags():Array { return _themeTags; }	
		
	}
	
}