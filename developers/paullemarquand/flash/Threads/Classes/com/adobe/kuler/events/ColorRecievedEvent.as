package com.adobe.kuler.events 
{	import flash.events.Event;
	
	/**	 * @author plemarquand	 */	public class ColorRecievedEvent extends Event 
	{
		public static const COLORS_RECIEVED : String = "colorsRecieved";
				private var _colors : Array;
		
		public function get colors() : Array
		{
			return _colors;
		}

		public function ColorRecievedEvent(type : String, colors : Array)
		{
			_colors = colors;			super( type, false, false );		}
	}}