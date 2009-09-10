package com.adobe.kuler.swatches.swatch.color 
{

	/**
	 * ...
	 * @author ...
	 */
	public class Color 
	{
		private var _swatchHexColor : String;
		private var _swatchColorMode : String;
		private var _swatchChannel1 : int;
		private var _swatchChannel2 : int;
		private var _swatchChannel3 : int;
		private var _swatchChannel4 : int;
		private var _swatchIndex : int;
		
		public function Color(data : XML) 
		{
			var xml : XML = data;
			var kuler : Namespace = xml.namespace( "kuler" );
			for each(var color:XML in data)
			{
				_swatchHexColor = color.kuler::swatchHexColor;			
				_swatchColorMode = color.kuler::swatchColorMode;
				_swatchChannel1 = color.kuler::swatchChannel1;
				_swatchChannel2 = color.kuler::swatchChannel2;
				_swatchChannel3 = color.kuler::swatchChannel3;
				_swatchChannel4 = color.kuler::swatchChannel4;
				_swatchIndex = color.kuler::swatchIndex;
			}
		}

		public function get swatchHexColor() : String 
		{ 
			return _swatchHexColor; 
		}

		public function get swatchColorMode() : String 
		{ 
			return _swatchColorMode; 
		}

		public function get swatchChannel1() : int 
		{ 
			return _swatchChannel1; 
		}

		public function get swatchChannel2() : int 
		{ 
			return _swatchChannel2; 
		}

		public function get swatchChannel3() : int 
		{ 
			return _swatchChannel3; 
		}

		public function get swatchChannel4() : int 
		{ 
			return _swatchChannel4; 
		}

		public function get swatchIndex() : int 
		{ 
			return _swatchIndex; 
		}

		public function toString() : String 
		{
			var pair1 : String = new String( );
			pair1 = _swatchHexColor.substr( 0, 2 );
			var pair2 : String = new String( );
			pair2 = _swatchHexColor.substr( 2, 2 );
			var pair3 : String = new String( );
			pair3 = _swatchHexColor.substr( 4, 2 );
			
			var r : Number = parseInt( pair1, 16 );
			var g : Number = parseInt( pair2, 16 );
			var b : Number = parseInt( pair3, 16 );
			return RGBtoHEX( r, g, b ).toString();
		}
		
		private static function RGBtoHEX(r : Number,g : Number,b : Number) : Number
		{
			return ( r << 16 | g << 8 | b);
		}
	}
}