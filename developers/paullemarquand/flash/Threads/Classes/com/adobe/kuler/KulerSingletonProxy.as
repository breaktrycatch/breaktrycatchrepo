package com.adobe.kuler
{

	import com.adobe.kuler.events.GetResultEvent;
	import com.adobe.kuler.swatches.swatch.Swatch;
	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.util.binding.BindableObject;
	import flash.utils.Dictionary;

	/**
	 * @author Paul
	 */
	public class KulerSingletonProxy extends BindableObject
	{
		private static var instance : KulerSingletonProxy;
		private var _kulerService : KLibService;
		private var _callCache : Dictionary;
		private var _resultsCache : Dictionary;
		private var isFetching : Boolean;

		public function KulerSingletonProxy(pvt : SingletonEnforcer)
		{
			pvt = null;
			_kulerService = new KLibService( "69D81F497DDFD7D34D87FD489FF1EB7E" );
			_callCache = new Dictionary();
			_resultsCache = new Dictionary();
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
			instance ||= new KulerSingletonProxy( new SingletonEnforcer() );
			return instance;
		}

		public function getRandomColours() : void
		{
			if (isFetching)
			{
				return;
			}

			isFetching = true;
			trace( "KulerSingletonProxy.getRandomColours(", [], ")" );
			var handler : Function = function(e : GetResultEvent) : void
			{
				trace( "KulerSingletonProxy.handler(", [ e.results.title ], ")" );
				_kulerService.removeEventListener( GetResultEvent.GET_RESULTS, arguments.callee );
				dispatchResults( processResults( e.results.swatches ) );
			};
			_kulerService.addEventListener( GetResultEvent.GET_RESULTS, handler );
			_kulerService.getPopular( 0, 20 );
		}

		public function get result() : Array
		{
			return get( 'result' );
		}

		public function set result(value : Array) : void
		{
			set( 'result', value );
		}

		private function processResults(results : Array) : Array
		{
			var arr : Array = [];
			
			for (var i : int = 0; i < results.length; i++)
			{
				var item : Swatch = results[i];
				arr.push( item.hexColorArray );
			}
			
			return arr;
		}

		private function dispatchResults(rawResult : Array) : void
		{
			result = rawResult;
			trace( "DISPATCHING RESULTS!: " + result );
		}
	}
}
internal class SingletonEnforcer
{
}