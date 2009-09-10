/**
 * @author         plemarquand LeMarquand
 * @published      March 2007
 * @playerversion  Flash 9.0.16.0
 * 
 * <p>This is a package of static functions that can be used to transform colors between color spaces.</p>
 */

package com.breaktrycatch.color 
{

	public class ColorSpaceTransformations 
	{
		/**
		 * The ColorSpaceTransformations constructor should never be directly 
		 * instantiated from an instance.
		 */
		   
		public function ColorSpaceTransformations() : void 
		{
			throw new Error( "ColorSpaceTransformations is comprised of static methods only and cannot be instantiated." );
		}

		/**
		 * Transforms r, g, and b values to a single HEX number.
		 * 
		 * @param <Number> the Red value.
		 * @param <Number> the Blue value.
		 * @param <Number> the Green value.
		 *
		 * @return a HEX value.
		 */
		  
		public static function RGBtoHEX(r : Number,g : Number,b : Number) : Number
		{
			return ( r << 16 | g << 8 | b );
		}

		/**
		 * Transforms a HEX number into r, g and b properties attached to a generic object.
		 * 
		 * @param <uint> the HEX color you wish to convert.
		 * 
		 * @return an object with r, g, b parameters.
		 */
		public static function HEXtoRGB( val : uint ) : ColorObject 
		{
			var col : ColorObject = new ColorObject( );
			col.r = ( val >> 16 ) & 0xFF;
			col.g = ( val >> 8 ) & 0xFF;
			col.b = val & 0xFF;
			return col;
		}

		/**
		 * Transforms an object with r, g, b properties into a grayscale HEX color.
		 * 
		 * @param <uint> An object with r, g, b properties.
		 * 
		 * @return a grayscale HEX color.
		 */
		public static function RGBtoHEXGrayScale( col : uint ) : Number 
		{
			var colObj : ColorObject = HEXtoRGB( col );
			colObj.r = 0.114 * colObj.r;
			colObj.g = 0.299 * colObj.g;
			colObj.b = 0.587 * colObj.b;
			return colObj.r + colObj.g + colObj.b;
		}
	}
}