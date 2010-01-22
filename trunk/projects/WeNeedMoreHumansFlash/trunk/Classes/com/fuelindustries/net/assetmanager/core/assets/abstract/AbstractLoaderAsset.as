package com.fuelindustries.net.assetmanager.core.assets.abstract {
	import com.fuelindustries.net.assetmanager.core.assets.Asset;

	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * @author jkeon
	 */
	public class AbstractLoaderAsset extends Asset {
		
		protected var __loader:Loader;
		
		public function AbstractLoaderAsset(_assetName : String, _path : String) {
			super(_assetName, _path);
			__loader = new Loader();
		}
		
		protected override function load(_urlRequest:URLRequest, _context:LoaderContext):void {
			__loader.load(_urlRequest, _context);
		}
		
		public override function get loaderDispatcher():EventDispatcher {
			//override
			return __loader.contentLoaderInfo;
		}
		public override function get loaderSecurityDispatcher():EventDispatcher {
			//override
			return __loader;
		}
		
		public override function close():void {
			__loader.close();
		}
		
		public override function unload():void {
			__loader.unload();
		}
		
		
	}
}
