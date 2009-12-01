package com.breaktrycatch.collection.util 
{

	/**
	 * This utility class contains several filters for the
	 * Array.filter method, creates new arrays based on 
	 * @author plemarquand
	 */
	public class FilterUtil 
	{
		/**
		 * Filter callback to be used with array.filter().
		 * Returns every element with an even array index.
		 */
		public static function filterEven(array : Array) : Array
		{
			return array.filter(internalEvenFilter);
		}

		/**
		 * Filter callback to be used with array.filter().
		 * Returns every element with an odd array index.
		 */
		public static function filterOdd(array : Array) : Array
		{
			return array.filter(internalOddFilter);
		}

		/**
		 * Filters a range of numerical elements and returns elements between [min, max].
		 * The search is inclusive, such that elements less than or equal too the min are returned,
		 * and likewise for the max.
		 */
		public static function filterRange(array : Array, min : Number, max : Number) : Array 
		{
			var rFilter : RangeFilter = new RangeFilter(min, max);
			return rFilter.filter(array);
		}
		
		/**
		 * Filters a range of dates and returns elements between [min, max].
		 * The search is inclusive, such that elements less than or equal too the min are returned,
		 * and likewise for the max.
		 */
		public static function filterDates(array : Array, min : Date, max : Date) : Array
		{
			var dFilter : DateFilter = new DateFilter(min, max);
			return dFilter.filter(array);
		}
		
		/**
		 * Filters an array of strings against an array of acceptable strings.
		 * @param acceptableStrings An array of acceptable strings.
		 * @param array An Array of strings to filter. 
		 * @param exclusive Specifies an exclusive search. If true, all strings that are not in the acceptableStrings array are returned.
		 * @return A list of filtered strings.
		 */
		public static function filterStringList(acceptableStrings : Array, array : Array, exclusive : Boolean = false) : Array
		{
			var sFilter : StringFilter = new StringFilter(acceptableStrings, exclusive);
			return sFilter.filter(array);
		}
		
		private static function internalEvenFilter(item : *, index : int, array : Array) : Boolean 
		{
			item = array = null;
			return Boolean(index % 2);
		}

		private static function internalOddFilter(item : *, index : int, array : Array) : Boolean 
		{
			item = array = null;
			return Boolean(index - 1 % 2);
		}
	}
}

internal class DateFilter
{
	private var __min : Date;
	private var __max : Date;
	
	public function DateFilter(min : Date, max : Date) 
	{
		__min = min;
		__max = max;
	}
	
	public function filter(array : Array) : Array
	{
		return array.filter(rangeFilter);
	}

	private function rangeFilter(item : *, index : int, array : Array) : Boolean 
	{
		array = null;
		index = 0;
		return Boolean(item >= __min && item <= __max);
	}
}

internal class RangeFilter
{
	private var __min : Number;
	private var __max : Number;

	public function RangeFilter(min : Number, max : Number) 
	{
		__min = min;
		__max = max;
	}

	public function filter(array : Array) : Array
	{
		return array.filter(rangeFilter);
	}

	private function rangeFilter(item : *, index : int, array : Array) : Boolean 
	{
		array = null;
		index = 0;
		return Boolean(item >= __min && item <= __max);
	}
}


import flash.utils.Dictionary;

internal class StringFilter
{
	private var __acceptable : Dictionary;
	private var __exclusive : Boolean;

	public function StringFilter(acceptable : Array, exclusive : Boolean) 
	{
		__acceptable = new Dictionary(true);
		var val : String;
		acceptable = acceptable.slice();
		while(acceptable.length > 0) 
		{
			val = acceptable.pop();
			__acceptable[val] = true;
		}
		
		__exclusive = exclusive;
	}

	public function filter(array : Array) : Array
	{
		return (__exclusive) ? (array.filter(exclusiveRangeFilter)) : (array.filter(inclusiveRangeFilter));
	}

	private function inclusiveRangeFilter(item : *, index : int, array : Array) : Boolean 
	{
		array = null;
		index = 0;
		return Boolean(__acceptable[item]);
	}

	private function exclusiveRangeFilter(item : *, index : int, array : Array) : Boolean 
	{
		array = null;
		index = 0;
		return !Boolean(__acceptable[item]);
	}
}
