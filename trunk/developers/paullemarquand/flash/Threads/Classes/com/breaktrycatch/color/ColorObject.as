package com.breaktrycatch.color 
{

	/**
	 * @author plemarquand
	 */
	public class ColorObject 
	{
		public var __r : Number;
		public var __g : Number;
		public var __b : Number;
		public var __a : Number;

		public function add( n : Number ) : void
		{
			r += n;
			g += n;
			b += n;
			a += n;
		}

		public function sub( n : Number ) : void
		{
			r -= n; 
			g -= n;
			b -= n;
			a -= n;
		}

		public function multi( n : Number ) : void
		{
			r *= n;
			g *= n;
			b *= n;
			a *= n;
		}

		public function div( n : Number ) : void
		{
			r /= n;
			g /= n;
			b /= n;
			a /= n;
		}

		public function set r( rC : Number ) : void
		{
			__r = rC;
			if( __r < 0 )
				__r = 0;
			else if ( __r > 255 )
				__r = 255;
		}

		public function set g( gC : Number ) : void
		{
			__g = gC;
			if( __g < 0 )
				__g = 0;
			else if ( __g > 255 )
				__g = 255;
		}

		public function set b( bC : Number ) : void
		{
			__b = bC;
			if( __b < 0 )
				__b = 0;
			else if ( __b > 255 )
				__b = 255;
		}
		public function set a( bC : Number ) : void
		{
			__a = bC;
			if( __a < 0 )
				__a = 0;
			else if ( __a > 255 )
				__a = 255;
		}

		public function get r() : Number
		{
			return __r;
		}

		public function get g() : Number
		{
			return __g;
		}

		public function get b() : Number
		{
			return __b;
		}

		public function get a() : Number
		{
			return __a;
		}

		public function set color( n : Number ) : void
		{
			a = ( n >> 24 ) & 0xFF;
			r = ( n >> 16 ) & 0xFF;
			g = ( n >> 8 ) & 0xFF;
			b = n & 0xFF;
		}

		public function get hex() : int
		{
			return ( __a << 24 | __r << 16 | __g << 8 | __b );	
		}
	}
}
