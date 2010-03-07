package com.fuelindustries.utils
{
	/**
	 * A set of Color Helper Methods
	 */
	 	
	public class ColorUtils
	{
		/**
		 * Converts Alpha, Red, Green, Blue values to a hex value
		 * @param a Alpha value
		 * @param r Red Value
		 * @param g Green Value
		 * @param b Blue Value
		 * @return The converted hex value
		 * @see ColorUtils#rgbToHex()
		 */
		public static function argbToHex( a:Number, r:Number, g:Number, b:Number ):uint
		{
			return( ( a<<24 ) |( r<<16 ) |( g<<8 )|( b ) );
		}
		
		/**
		 * Converts Red, Green, Blue values to a hex value
		 * @param r Red Value
		 * @param g Green Value
		 * @param b Blue Value
		 * @return The converted hex value
		 * @see ColorUtils#argbToHex()
		 */
		public static function rgbToHex( r:uint, g:uint, b:uint ):uint
		{
			return( r<<16 | g<<8 | b );
		}
		
		/**
		 * Returns the Alpha value from a ARGB Hex value
		 * @param hex The Hex value
		 * @return The Alpha value
		 */
		public static function getAlpha( hex:uint ):uint
		{
			return( (hex >> 24) & 0xFF );	
		}
		
		/**
		 * Returns the Red value from a ARGB or RGB Hex value
		 * @param hex The Hex value
		 * @return The Red value
		 */
		public static function getRed( hex:uint ):uint
		{
			return( (hex >> 16) & 0xFF );	
		}

		/**
		 * Returns the Greed value from a ARGB or RGB Hex value
		 * @param hex The Hex value
		 * @return The Greed value
		 */
		public static function getGreen( hex:uint ):uint
		{
			return( (hex >> 8) & 0xFF );	
		}
		
		/**
		 * Returns the Blue value from a ARGB or RGB Hex value
		 * @param hex The Hex value
		 * @return The Blue value
		 */
		public static function getBlue( hex:uint ):uint
		{
			return( hex  & 0xFF );	
		}
	}
}