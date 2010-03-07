package com.fuelindustries.utils
{
	/**
	 * A set of Array Helper Methods
	*/
		
	public class ArrayUtils
	{
		
		/**
		 * Returns a clone of an Array
		 * @param arr The Array to be cloned
		 * @return The cloned array
		*/
		public static function clone( arr:Array ):Array
		{
			var newarr:Array = [];
			for( var i:int=0; i<arr.length; i++ )
			{
				newarr.push( arr[ i ] );
			}
			return( newarr );
		}
		
		/**
		 * Shuffles an Array.
		 * Log
		 * Dev. 2007 - Fixed random invalid index (Darren Schnare)
		 * @param arr The Array to be shuffled
		 * @return The shuffled array		 
		*/
		public static function shuffle( arr:Array ):Array
		{			
			var last:int = arr.length-1;
			var i:int = last+1; 
			while( i-- ) 
			{ 
				var p:int = NumberUtils.randomBetween( 0, last ); 
				var t:Object = arr[ i ]; 
				arr[ i ] = arr[ p ]; 
				arr[ p ] = t; 
			} 
			return( arr );		
		}
		
		
		
		/**
		 * Removes any duplicates from an Array.
		 * This will only work if the entries are not Objects.
		 * @param arr The Array to be effected
		 * @return An array with no duplicate entries
		*/
	
		public static function removeDuplicates( arr:Array ):Array
		{
			for( var y:int=0; y<arr.length; ++y )
			{
	            var ty:Object = arr[ y ];  
				for( var z:int=( y + 1 ); z<arr.length; ++z )
				{
					while( ty == arr[ z ] )
					{
						arr.splice( z, 1 );
					}
				}
			}
			return( arr );	
		}
		
		/**
		 * Finds the nearest item in the array - 
		 * Items in arrays must be values( numbers)
		 * @param p_value The number to check against
		 * @param p_arr The Array to be looked against
		 * @return The index of the nearest item
		*/
		public static  function findNearest(p_value:Number, p_arr:Array):Number {
		
			var score:Number = Infinity;
		    var test:Number;
			var index:Number;
			var i:Number = 0;
			var l:Number = p_arr.length;
			while (i < l) {
				test = Math.abs(p_arr[i]-p_value);
			
				if(test < score){
					score = test;
					index = i;
					
				}
				i++;
			}
			return index;
		}				
	}
}