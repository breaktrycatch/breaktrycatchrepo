package com.fuelindustries.net.assetmanager.core.assets.abstract {
	import com.fuelindustries.net.assetmanager.core.assets.Asset;

	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * @author jkeon
	 */
	public class AbstractURLLoaderAsset extends Asset {
		
		protected var __loader:URLLoader;
		
		public function AbstractURLLoaderAsset(_assetName : String, _path : String) {
			super(_assetName, _path);
			__loader = new URLLoader();
		}
		
		protected override function load(_urlRequest:URLRequest, _context:LoaderContext):void {
			_context = null;
			__loader.load(_urlRequest);
		}
		
		public override function get loaderDispatcher():EventDispatcher {
			//override
			return __loader;
		}
		public override function get loaderSecurityDispatcher():EventDispatcher {
			//override
			return __loader;
		}
		public override function close():void {
			__loader.close();
		}
		
		public override function unload():void {
			//Does nothing
		}
	}
}
