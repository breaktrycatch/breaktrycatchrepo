package com.util
{

	/**
	 * A set of Number helper methods
	 */
	 
	public class NumberUtils
	{

		public static function sign(num : Number) : Number
		{
			return (num >= 0) ? (1) : (-1);
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
		
		/**
		 * Returns a random number between 2 given values
		 * @param min The minimum number in the range
		 * @param max The maximum number in the range
		 * @return The random number
		 */
		public static function randomBetween( low:int, high:int ):int
		{
			return( Math.round(Math.random() * (high - low)) + low );	
		}
		
		/**
		 * Formats a number to add the appropreiate cents value
		 * @param num The number to add the cents value to
		 * @return The a new string with the cents added
		 */
		public static function addCents( num:Number ):String
		{
			var a:Array = ( ( Math.round( num * 100 ) / 100 ) + "" ).split( "." );
			
			if( a[ 1 ] != undefined )
			{
				a[ 1 ] = ( a[ 1 ] + "00" ).substr( 0, 2 );
			}
			else
			{
				a[ 1 ] = "00";
			}
	 		
			return( a.join( "." ) );
		}
		
		/**
		 * Retruns a String with added zeros to the begging.
		 * Comes in handy when wanting to right justify numbers in a textfield or in a countdown.
		 * @param num The number to add Zeros to
		 * @param amount The amount of zeros to pad
		 * @return A new string with the added zeros at the start of the number
		 */
		public static function padZero( num:Number, amount:Number ):String
		{
			var str:String = String( num );
			while( str.length < amount )
			{
				str = '0' + str;
			}
			
			return( str );
		}
		
		/**
         * Returns the milliseconds when you pass it a time stamp string
         * hh:mm:ss:ms
         * 
         * @param string The time stamp string to be converted ( hh:mm:ss:ms)
         * @return A number representing the milliseconds the timestamp would have
         */
		 public static function getMSFromTimestamp(p_time:String):Number 
		{
			var match:Object = /(\d+):(\d+):(\d+)(:(\d+))?/.exec(p_time);
			
			var h:Number = (parseInt(match[1]) || 0) * 60*60*1000;
			var m:Number = (parseInt(match[2]) || 0) * 60*1000;
			var s:Number = (parseInt(match[3]) || 0) * 1000;
			var ms:Number=(parseInt(match[5]) || 0);
			
			return h + m + s + ms;
		}
		
		public static function degreeToRad(deg : Number) : Number 	
		{ 
			return deg * (Math.PI / 180); 
		}

		public static function radToDegree(rad : Number) : Number
		{
			return rad * ( 180 / Math.PI); 
		}
	}
}