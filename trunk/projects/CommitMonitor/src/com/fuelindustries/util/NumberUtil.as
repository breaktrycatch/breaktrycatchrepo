package com.fuelindustries.util
{
	/**
	 * @author plemarquand
	 */
	public class NumberUtil 
	{
		/**
		 * Takes an integer and returns a comma delimited version of the string.
		 * Commas are added every 3 numbers. Ex: 1000000 converts to: 1,000,000
		 * @param value An integer to add commas to
		 * @return A comma delimited pretty String.
		 */
		public static function commaDelimitInt(value : int) : String
		{
			var a : Array = new Array();
			var sp : Array = value.toString().split("");
			var i : Number = sp.length;
			var j : Number = -1;
			
			while( --i >= 0 )
			{
				if( !( ++j % 3) )
				{
					if( j != 0 ) a.push(",");
					a.push(sp[i]);
				}
				else
				{
					a.push(sp[i]);
				}
			}
			
			a.reverse();
			return a.join("");
		}
		
		/**
		 * Constrains a number between a given range
		 * @param num The number to constrain
		 * @param min The minimum number in the range
		 * @param max The maximum number in the range
		 * @return The constrained number
		 */
		public static function constrain( num:Number, min:Number, max:Number ):Number
		{
			return( Math.max( min, Math.min( num, max ) ) );
		}
	}
}