package com.module_assets.net.assets.abstract {
	import com.module_assets.net.assets.Asset;
	
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * @author jkeon
	 */
	public class AbstractSoundAsset extends Asset {
		
		protected var __loader:Sound;
		
		public function AbstractSoundAsset(_assetName : String, _path : String) {
			super(_assetName, _path);
			__loader = new Sound();
		}
		
		protected override function load(_urlRequest:URLRequest, _context:LoaderContext):void {
			_context = _context;
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
			//DO NOTHING
		}
		
		
	}
}
