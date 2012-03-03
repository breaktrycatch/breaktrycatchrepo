package com.util
{

	import flash.utils.getTimer;
	import flash.utils.Dictionary;

	/**
	 * @author plemarquand
	 */
	public class Profiler
	{
		private var __workingIds : Dictionary;
		private var __timesCalled : Dictionary;
		private var __results : Dictionary;
		private var __total : Number;

		public function Profiler()
		{
			reset();
		}

		public function reset() : void
		{
			__results = new Dictionary();
			__workingIds = new Dictionary();
			__timesCalled = new Dictionary();
		}

		public function start(id : String) : void
		{
//			if(!__timesCalled[id])
//			{
//				__workingIds[id] = getTimer();
//				__timesCalled[id] = 1;
//			}
//			else
//			{
//				__timesCalled[id]++;
//			}
		}

		public function stop(id : String) : void
		{
//			if (__workingIds[id] && __timesCalled[id] == 1)
//			{
//				var result : int = getTimer() - __workingIds[id];
//				__results[id] ||= [];
//				(__results[id] as Array).push( result );
//				delete __workingIds[id];
//				delete __timesCalled[id];
//			} 
//			else if(__timesCalled[id] > 1)
//			{
//				__timesCalled[id]--;
//			}	
//			else
//			{
//				throw new ArgumentError( "Stopped " + id + " before starting it!" );
//			}
		}

		public function showResults() : void
		{
//			__total = 0;
//			var longestKey : int = 0;
//			var averages : Dictionary = new Dictionary();
//			var sums : Dictionary = new Dictionary();
//			for (var key : String in __results)
//			{
//				var results : Array = __results[key];
//				var sum : Number = sum( results );
//				var avg : Number = sum / results.length;
//				averages[key] = avg;
//				sums[key] = sum;
//
//				if (key.length > longestKey)
//				{
//					longestKey = key.length;
//				}
//			}
//
//			trace( "\n" );
//			var orderArr : Array = [];
//			for (var averageKey : String in averages)
//			{
//				var tabs : String = createTabs( Math.ceil( (longestKey - averageKey.length + 1) / 8 ) );
//				var average : Number = Math.round( 1000 * (averages[averageKey] ) ) / 1000;
//				var percent : Number = Math.round( 1000 * ((sums[averageKey] / __total) * 100) ) / 1000;
//				var output : String = averageKey + tabs + "avg. " + average + " ms.\t" + percent + "% of total exec time\t(" + (__results[averageKey] as Array).length + " executions)";
//				orderArr.push( { percent:percent, data:output } );
//			}
//
//			orderArr.sortOn( 'percent', Array.NUMERIC | Array.DESCENDING );
//			orderArr.forEach( function(_data : Object, ...args) : void
//			{
//				trace( _data['data'] );
//			} );
//
//			trace( "Total profiled time " + __total + " ms.\n" );
		}

		private function createTabs(_num : int) : String
		{
			var str : String = "";
			for (var i : int = 0; i < _num; i++)
			{
				str += "\t";
			}
			return str;
		}

		private function sum(_arr : Array) : Number
		{
			var sum : Number = 0;
			for (var i : int = 0; i < _arr.length; i++)
			{
				sum += _arr[i];
				__total += _arr[i];
			}
			return sum;
		}
	}
}
