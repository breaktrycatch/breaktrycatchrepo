package com.adobe.kuler 
{

	/**
	 * @author Paul
	 */
	public class KulerSingletonProxy 
	{
		private static var instance : KulerSingletonProxy;
		
		private var _kulerService : KLibService;
		
		public function KulerSingletonProxy(pvt : SingletonEnforcer)
		{
			pvt = null;
			_kulerService = new KLibService("69D81F497DDFD7D34D87FD489FF1EB7E");
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
		
	}
}

internal class SingletonEnforcer {}