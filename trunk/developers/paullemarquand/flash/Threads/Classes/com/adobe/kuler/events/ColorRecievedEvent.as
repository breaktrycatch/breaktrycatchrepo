package com.adobe.kuler.events 
{
	
	/**
	{
		public static const COLORS_RECIEVED : String = "colorsRecieved";
		
		
		public function get colors() : Array
		{
			return _colors;
		}

		public function ColorRecievedEvent(type : String, colors : Array)
		{
			_colors = colors;
	}