package com.humans.utils.elements {
	import com.humans.utils.events.BitmapLoadedEvent;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author jkeon
	 */
	public class BitmapLoaderInstance extends EventDispatcher {
		
		protected var __bitmapLoader:Loader;
		protected var __onSuccessFunction:Function;
		protected var __onFailureFunction:Function;
		protected var __onProgressFunction:Function;
		
		protected var __loaderContext:LoaderContext;
		protected var __urlRequest:URLRequest;
		
		public function BitmapLoaderInstance(_url:String, _handlerSuccessFunction:Function = null, _handlerErrorFunction:Function = null, _handlerProgressFunction:Function = null) {
			super();
			
			__onSuccessFunction = _handlerSuccessFunction;
			__onFailureFunction = _handlerErrorFunction;
			__onProgressFunction = _handlerProgressFunction;
			
			__loaderContext = new LoaderContext();	
			__loaderContext.checkPolicyFile = true;
			__loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
			__urlRequest = new URLRequest();
			__urlRequest.url = _url;
			
			__bitmapLoader = new Loader();
			__bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapComplete);
			__bitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onBitmapProgress);
			__bitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBitmapError);
			__bitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onBitmapError);
			__bitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onBitmapError);
			__bitmapLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onBitmapError);
			
			
		}
		
		public function loadBitmap():void {
			__bitmapLoader.load(__urlRequest, __loaderContext);
		}
		
		protected function onBitmapComplete(e:Event):void {
			dispatchEvent(new BitmapLoadedEvent(BitmapLoadedEvent.BITMAP_LOADED, (__bitmapLoader.content as Bitmap).bitmapData));
			if (__onSuccessFunction != null) {
				__onSuccessFunction((__bitmapLoader.content as Bitmap).bitmapData);
			}
			destroy();
		}
		protected function onBitmapProgress(e:ProgressEvent):void {
			if (__onProgressFunction != null) {
				__onProgressFunction(e.bytesLoaded/e.bytesTotal);
			}
		}
		protected function onBitmapError(e:Event):void {
			dtrace("bitmap error " + e);
			if (__onFailureFunction != null) {
				__onFailureFunction(e);	
			}
			destroy();
		}
		
		protected function destroy():void {
			__bitmapLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBitmapComplete);
			__bitmapLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onBitmapProgress);
			__bitmapLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBitmapError);
			__bitmapLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onBitmapError);
			__bitmapLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onBitmapError);
			__bitmapLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onBitmapError);
			
			try {
				__bitmapLoader.close();
			}
			catch (e:Error) {
				//DO NOTHING
			}
			
			__bitmapLoader = null;
			__onSuccessFunction = null;
			__onFailureFunction = null;
			__onProgressFunction = null;
			__loaderContext = null;
			__urlRequest = null;

		}
	}
}
