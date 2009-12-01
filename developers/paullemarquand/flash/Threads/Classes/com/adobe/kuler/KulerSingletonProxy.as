package com.adobe.kuler 
{
	import com.adobe.kuler.events.ColorRecievedEvent;
	import com.adobe.kuler.events.GetResultEvent;
	import com.adobe.kuler.swatches.swatch.Swatch;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * @author Paul
	 */
	public class KulerSingletonProxy extends EventDispatcher
	{
		private static var instance : KulerSingletonProxy;

		private var _kulerService : KLibService;
		private var _callCache : Dictionary;
		private var _resultsCache : Dictionary;

		public function KulerSingletonProxy(pvt : SingletonEnforcer)
		{
			pvt = null;
			_kulerService = new KLibService( "69D81F497DDFD7D34D87FD489FF1EB7E" );
			_callCache = new Dictionary( );
			_resultsCache = new Dictionary( );
		}

		public function get service() : KLibService
		{
			return _kulerService;
		}

		/**
		 * Returns the only instance of <code>KulerSingletonProxy</code>.
		 */
		public static function getInstance() : KulerSingletonProxy 
		{
			if( instance == null ) 
			{
				instance = new KulerSingletonProxy( new SingletonEnforcer( ) );
			}
			return instance;
		}

		public function getRandomColours() : void
		{	
			callFunction( _kulerService.getRandom, 0, 5);
		}
		
		private function callFunction(fn : Function, ...args) : void
		{
			// todo: checking the cache doesn't check the arguments passed in.
			var results : Array = checkResultsCache( fn );
			trace("Do we have results? ", results, "in call cache", checkCallCache(fn))
			if(results)
			{
				dispatchResults( results );
				return;
			}
			else if(checkCallCache( fn ))
			{
				return;
			}
			
			_callCache[fn] = true;
			var handler : Function = function(e : GetResultEvent) : void 
			{
				_resultsCache[fn] = processResults(e.results.swatches);
				_kulerService.removeEventListener(GetResultEvent.GET_RESULTS, arguments.callee);
				dispatchResults( _resultsCache[fn]);
			};
			_kulerService.addEventListener( GetResultEvent.GET_RESULTS, handler );
			_kulerService.getRandom( 0, 5 );
		}
		
		private function processResults(results : Array) : Array
		{
			var arr : Array = ArrayExtensions.aggregate(results, [], function(seed : Array, item : Swatch) : Array
			{
				return seed.concat(item.hexColorArray);
			} );
			return arr;
		}

		private function dispatchResults(results : Array) : void
		{
			trace("DISPATCHING RESULTS!: " + results);
			dispatchEvent( new ColorRecievedEvent(ColorRecievedEvent.COLORS_RECIEVED, results) );
		}

		private function checkCallCache(fn : Function) : Boolean
		{
			return _callCache[fn];
		}

		private function checkResultsCache(fn : Function) : *
		{
			return _resultsCache[fn];
		}
	}
}

internal class SingletonEnforcer {}