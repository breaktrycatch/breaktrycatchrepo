package com.fuelindustries.util
{
	/**
	 * @author plemarquand
	 */
	public class ArrayExtensions 
	{		/**
		 * Runs an aggregator function on the supplied array and returns the result.
		 * This is the equivalent to reduce in other languages, or aggregate in C#.
		 * @param array An array of items to aggregate.
		 * @param seed The seed object. The results of the aggregate are stored on this object. 
		 * If the object is a primitive type, a primitive is returned.
		 * @param callback The aggregator function with the signature <code>function(seed : *, item : *):*</code>.
		 * @return The aggregated value.
		 * 
		 * <code>
		 * var arr2 : Array = ["a","b","C","d","e"];
		 * var seed : String = ArrayExtensions.aggregate(arr2, "", function(n : *,newN : *):*
		 * {
		 * 	return n + newN;
		 * });
		 * trace("Aggregated Result: " + seed) // traces: abCde.
		 * </code>
		 */
		public static function aggregate(array : Array, seed : *, callback : Function) : *
		{
			var isPrimitive : Boolean = ObjectUtil.isSimple( seed );
			simpleForEach( array, function(item : *):void
			{
				if(isPrimitive)
				{
					seed = callback( seed, item );
				}
				else
				{
					callback( seed, item );
				}
			} );
			return seed;
		}
		/**
		 * Transforms the supplied array to be unique.
		 * @param arr An array with potentially duplicate elements in it.
		 * @return The transformed array. Operations are made on the original array.
		 */
		public static function distinct(arr : Array) : Array
		{
			return arr.filter( function (item : *, index : int, array : Array):Boolean 
			{
				return array.indexOf( item, index + 1 ) == -1;
			} );
		}
		/**
		 * Returns a boolean indicating if all of the elements in the array meet
		 * the conditions defined in the predicate.
		 * @param arr An array of elements to check against the predicate.
		 * @param callback A predicate function with the signature <code>function(item : *, index : int, array : Array):Boolean</code>
		 * @return Whether all the elements in the array satisfy the predicate or not.
		 */
		public static function equalAll(arr : Array, callback : Function) : Boolean
		{
			return !arr.some( function(item : *, index : int, array : Array):Boolean 
			{
				return !callback( item, index, array );
			} );
		}
		/**
		 * Produces the set difference of the first array against the second.
		 * @param arr1 An array of elements to perform the except on.
		 * @param arr2 An array of elements to remove from the first set.
		 * @return All elements contained within the first array that are not present in the second.
		 */
		public static function except(arr : Array, except : Array) : Array
		{
			return arr.filter( function(item : *, ...args):Boolean
			{
				return except.indexOf( item ) == -1;
			} );
		}
		/**
		 * Returns the first element in an array that matches the given condition.
		 * @param arr An array of elements to search with the predicate function
		 * @param callback A predicate function with the signature <code>function(item : *, index : int, array : Array):Boolean</code>
		 * @return The first matching element based on the criteria set in the predicate function.
		 */
		public static function first(arr : Array, callback : Function) : *
		{
			var savedIndex : int = -1;
			arr.some( function(item : *, index : int, array : Array):Boolean 
			{
				if(callback( item, index, array ))
				{
					savedIndex = index;
					return true;
				}
				return false;
			} );
			
			return (savedIndex == -1) ? (null) : (arr[savedIndex]);
		}
		/**
		 * Returns the first element in an array whose property matches the supplied
		 * value. For example, if you're looking for user.id:
		 * ArrayExtensions.firstByProperty(userArray, 'id', 12345);
		 * @param arr An array to search.
		 * @param property A property name that is contained on all objects in the array.
		 * @param searchValue A value to search for.
		 */
		public static function firstByProperty(arr : Array, property : String, searchValue : *) : *
		{
			return first( arr, function(item : *, ...args):Boolean
			{
				return item[property] == searchValue;
			} );	
		}
		/**
		 * Finds the common set of elements between two Arrays.
		 * @param arr1 An array of elements.
		 * @param arr2 Another array of elements.
		 * @return A new array containing the common set of elements between the arrays.
		 */
		public static function intersect(arr1 : Array, arr2 : Array) : Array
		{
			var larger : Array; 
			var smaller : Array;
			if(arr1.length > arr2.length)
			{
				larger = arr1;
				smaller = arr2;	
			}
			else
			{
				larger = arr2;
				smaller = arr1;	
			}
			
			return larger.filter( function(item : *, ...args):Boolean
			{
				return smaller.indexOf( item ) != -1;
			} );
		}
		/**
		 * Returns all elements of a supplied type.
		 * @param arr An array of elements.
		 * @param type The type of elements to search for in the array.
		 * @return A new array containing all the elements of the supplied type from the suppled array.
		 */
		public static function ofType(arr : Array, type : Class) : Array
		{
			return arr.filter( function(item : *, ...args) : Boolean
			{
				return item is type;
			} );
		}
		/**
		 * Returns the first n elements of an array. If n is greater than the length
		 * of the array, then the entire array is returned.
		 */
		public static function take(arr : Array, n : int) : Array
		{
			return arr.slice( 0, n );
		}
		/**
		 * Runs a predicate function on each element in the array and if the predicate returns
		 * true, then a callback function is run on the item.
		 * @param array An array of items to run the predicate/callback on.
		 * @param conditional A predicate function with the signature <code>function(item : *, index : int, array : Array):Boolean</code>
		 * @param callback A callback function with the signature <code>function(item : *, index : int, array : Array):void</code>
		 */
		public static function predicate(array : Array, conditional : Function, callback : Function) : void
		{
			array.forEach( function (item : *, index : int, array : Array):void
			{
				if(conditional( item, index, array ))
				{
					callback( item, index, array );
				}
			} );	
		}
		/**
		 * Returns a union between two two arrays excluding duplicate elements.
		 * @param arr1 The first array to join.
		 * @param arr2 The second array to join.
		 * @return An array that has been joined together excluding unique elements.
		 */
		public static function union(arr1 : Array, arr2 : Array) : Array
		{
			return distinct( arr1.concat( arr2 ) );
		}
		
		/**
		 * Creates a new array and removes duplicate items from it.
		 * @param An array to remove duplicates from
		 * @return A unique array.
		 */
		public static function unique(arr : Array) : Array
		{
			var newArr : Array = arr.concat();
			for( var i : int=0; i < newArr.length; ++i )
			{
				var ty : Object = newArr[ i ];  
				for( var j : int = i + 1; j < newArr.length; ++j )
				{
					while( ty == newArr[ j ] )
					{
						newArr.splice( j, 1 );
					}
				}
			}
			return arr;	
		}
		/**
		 * Returns a random element from an array. If the array is empty
		 * the function returns undefined.
		 * @param arr An array from which to select a random element.
		 * @return A random element from the array.
		 */
		public static function randomElement(arr : Array) : *
		{
			if ( arr.length == 0 )
			{
				return undefined;
			}
			return arr[ Math.floor( Math.random( ) * arr.length ) ];
		}
		/**
		 * Creates a new copy of the supplied array and randomizes its elements.
		 * @param arr An array to randomize.
		 * @return A new randomized array.
		 */
		public static function randomize(arr : Array) : Array
		{
			var len : Number = arr.length;
			var shuffled : Array = arr.concat( );
			var rnd : Number;
			var i : Number; // using a number here is *considerably* faster than an integer.
			var item : *;
			while (i < len) 
			{
				item = shuffled[i];
				shuffled[i] = shuffled[rnd = i + Math.random( ) * (len - i)];
				shuffled[rnd] = item;
				i++;
			}
			return shuffled;
		}
		/**
		 * Returns an array populated with a range of numbers. The range is inclusive,
		 * meaning that the start and end numbers will be included in the range. The
		 * start and end values can be any integer numbers in an order.
		 * @param start The start of the range.
		 * @param end The end point of the range.
		 * @return An array contianing a linear array of elements from start to start to end.
		 */
		public static function range(start : int, end : int) : Array
		{
			var higher : int = (start > end) ? (start) : (end);
			var lower : int = (start < end) ? (start) : (end);
			var direction : int = (end > start) ? (1) : (-1);
			var range : int = higher - lower;
			var ctr : int = 0;
			var arr : Array = [];
			var len : int = range;
			
			for ( var i : Number = 0; i <= len ; i++ ) 
			{
				arr.push( start + ctr );
				ctr += direction;
			}
			return arr;
		}
		/**
		 * Creates a copy of the original array and reverses it in place.
		 * @param arr An array to reverse.
		 * @return A new reversed array.
		 */
		public static function reverse(arr : Array) : Array
		{
			return arr.concat( ).reverse( );
		}
		/**
		 * A simple wrapper for Array.forEach that calls your callback function
		 * using only the item in the array as a parameter. For example, regular forEach
		 * requires a callback with the signature
		 * <code>function(item : *, index : int, array : Array):void;</code>
		 * however using this function the method signature is:
		 * <code>function(item : *):void;</code>
		 * @param items	An array of items to be passed to the callback one by one.
		 * @param callback The callback to be run.
		 */
		public static function simpleForEach(items : Array, callback : Function) : void
		{
			items.forEach( function(item : *, ...args):void
			{
				callback( item );
			} );
		}
		/**
		 * Executes a callback on every item in the array. The function must
		 * exist on all items in the supplied array.
		 * @param array An array of items to execute a callback on.
		 * @param callback The string name of a callback to execute on all functions.
		 * @param callbackArgs Arguments to supply to the callback.
		 */
		public static function executeCallbackOnArray(array : Array, callback : String, ...callbackArgs) : void
		{
			simpleForEach( array, function(item : *) : void
			{
				item[callback].apply( item, callbackArgs );
			} );
		}
	}
}