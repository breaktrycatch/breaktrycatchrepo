package com.fuelindustries.net.assetmanager.core.assets {
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * @author jkeon
	 */
	public class Asset extends EventDispatcher {
		
		protected var __assetName:String;
		protected var __path:String;
		protected var __fileType:String;
		protected var __completed:Boolean;
		protected var __bytesLoaded:uint;
		protected var __bytesTotal:uint;
		protected var __prepped:Boolean;
		
		public function Asset(_assetName:String, _path:String) {
			super();
			__assetName = _assetName;
			__completed = false;
			__path = _path;
			__bytesLoaded = 0;
			__bytesTotal = 1000;
			__prepped = false;
		}
		
		public function get complete():Boolean {
			return __completed;
		}
		public function get bytesLoaded():uint {
			return __bytesLoaded;
		}
		public function get bytesTotal():uint {
			return __bytesTotal;
		}
		public function get prepped():Boolean {
			return __prepped;
		}
		public function set prepped(_prepped:Boolean):void {
			__prepped = _prepped;
		}
		
		public function get loaderDispatcher():EventDispatcher {
			//override
			return null;
		}
		public function get loaderSecurityDispatcher():EventDispatcher {
			//override
			return null;
		}
		
		
		public function set complete(_completed:Boolean):void {
			__completed = _completed;
		}
		public function set bytesLoaded(_bytesLoaded:uint):void {
			__bytesLoaded = _bytesLoaded;
		}
		public function set bytesTotal(_bytesTotal:uint):void {
			__bytesTotal = _bytesTotal;
		}
		
		public function loadSelf(_context:LoaderContext):void {
			__completed = false;
			__bytesLoaded = 0;
			this.load(new URLRequest(__path), _context);
		}
		
		protected function load(_urlRequest:URLRequest, _context:LoaderContext):void {
			//Override
		}
		
		
		public function getFile():* {
			//OVERRIDE
			return null;
		}
		
		public function close():void {
			//override
		}
		
		public function unload():void {
			//override
		}
		
		
	}
}
