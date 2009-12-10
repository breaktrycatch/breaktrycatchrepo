package com.module_assets.net {
	import com.module_assets.events.AssetCompleteEvent;
	import com.module_assets.events.AssetProgressEvent;
	import com.module_assets.net.assets.Asset;
	import com.module_assets.net.assets.BitmapAsset;
	import com.module_assets.net.assets.MP3Asset;
	import com.module_assets.net.assets.SWFAsset;
	import com.module_assets.net.assets.XMLAsset;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;	

	/**
	 * @author jkeon
	 */
	public class AssetGroup extends EventDispatcher {
		
		protected var __group:int;
		protected var __assets:Dictionary;
		protected var __indexedAssets:Array;
		
		protected var __groupComplete:Boolean;
		protected var __loaderContext:LoaderContext;
		
		protected var __groupPaused:Boolean;
	
		protected var __tempAsset:Asset;
		
		protected var __loading:Boolean;
		
		protected var __queued:Boolean;
		
		protected var __prepped:Boolean;
		protected var __prepIndex:int;
		
		
		public function AssetGroup(_group:int, target : IEventDispatcher = null) {
			super(target);
			__group = _group;
			__assets = new Dictionary(true);
			__indexedAssets = [];
			__groupComplete = false;
			__loading = false;
			__queued = false;
			__prepped = false;
			__prepIndex = 0;
			__loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		}
		
		public function get loading():Boolean {
			return __loading;
		}
		
		public function get groupComplete():Boolean {
			return __groupComplete;
		}
		
		public function get groupPaused():Boolean {
			return __groupPaused;
		}
		
		public function get queued():Boolean {
			return __queued;
		}
		
		public function get groupId():int {
			return __group;
		}
		
		
		public function set queued(_queued:Boolean):void {
			__queued = _queued;
		}
		
		
		public function addAsset(_path:String):void {
			//The asset name is the filename with no extention
			var assetName:String = _path.slice(_path.lastIndexOf("/")+1, _path.lastIndexOf("."));
			var fileType:String = (_path.slice(_path.lastIndexOf(".")+1, _path.length)).toLowerCase();
			
			switch (fileType) {
				
				case "swf":
					__tempAsset = new SWFAsset(assetName, _path);
				break;
				
				case "png":
				case "bmp":
				case "jpg":
				case "jpeg":
					__tempAsset = new BitmapAsset(assetName, _path);
				break;
				
				case "xml":
					__tempAsset = new XMLAsset(assetName, _path);
				break;
				
				case "mp3":
					__tempAsset = new MP3Asset(assetName, _path);
				break; 
				
				
				
			}
			
			__assets[assetName] = __tempAsset;
			__indexedAssets.push(__tempAsset);
			
		}
		
		public function getFile(_filename:String):* {
			__tempAsset = __assets[_filename];
			return __tempAsset.getFile();
		}
		
		public function load(_prep:Boolean = true):void {
			
			if (_prep == false) {
				__prepped = true;
			}
			
			if (__indexedAssets.length <= 2) {
				__prepped = true;
			}
			
			if (__prepped) {
				__loading = true;
				if (__groupComplete == false) {
					for (var b in __assets) {
						__tempAsset = __assets[b] as Asset;
						
						__tempAsset.loaderDispatcher.addEventListener(Event.COMPLETE, onComplete);
						__tempAsset.loaderDispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress);
						__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
						__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
						__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
						__tempAsset.loaderSecurityDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
					
						__tempAsset.loadSelf(__loaderContext);
					}
				}
				else {
					__loading = false;
					dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE, __group));
				}
			}
			else {
				prepAssets();
			}
		}
		
		protected function prepAssets():void {
			__tempAsset = __indexedAssets[__prepIndex] as Asset;
				
			__tempAsset.loaderDispatcher.addEventListener(ProgressEvent.PROGRESS, onPrepProgress);
			__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
			__tempAsset.loaderDispatcher.addEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
			__tempAsset.loaderSecurityDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		
			__tempAsset.loadSelf(__loaderContext);
		}
		
		protected function onPrepProgress(e:ProgressEvent):void {
			__tempAsset = __indexedAssets[__prepIndex];
			
			__tempAsset.bytesLoaded = e.bytesLoaded;
			__tempAsset.bytesTotal = e.bytesTotal;
			__tempAsset.prepped = true;
			
			__tempAsset.loaderDispatcher.removeEventListener(ProgressEvent.PROGRESS, onPrepProgress);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
			__tempAsset.loaderSecurityDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			try {
				__tempAsset.close();
			}
			catch (error:Error) {
				//Uncomment if you're interested in seeing this. Otherwise don't worry about it, it will fail silently.
				//trace("[GROUP " + __group + "] - Could Not Close Asset - Most likely because it is already closed");
			}
			
			if (checkPrepProgress()) {
				__prepped = true;
				load();
			}
			else {
				__prepIndex++;
				prepAssets();
			}
		}
		
		protected function checkPrepProgress():Boolean {
			for (var b in __assets) {
				__tempAsset = __assets[b] as Asset;
				if (__tempAsset.prepped == false) {
					return false;
				}
			}
			return true;
		}
		
		public function pause():void {
			for (var b in __assets) {
				__tempAsset = __assets[b] as Asset;
				__tempAsset.loaderDispatcher.removeEventListener(Event.COMPLETE, onComplete);
				__tempAsset.loaderDispatcher.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
				__tempAsset.loaderSecurityDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				try {
					__tempAsset.close();
				}
				catch (e:Error) {
					//Uncomment if you're interested in seeing this. Otherwise don't worry about it, it will fail silently.
					//trace("[GROUP " + __group + "] - Could Not Close Asset - Most likely because it is already closed");
				}
			}
			__loading = false;
			__groupPaused = true;
		}
		
		//Loops through all assets in a group and checks their complete status
		protected function checkGroupComplete():void {
			
			var check:Boolean = true;
			
			for (var b in __assets) {
				__tempAsset = __assets[b] as Asset;
				if (__tempAsset.complete == false) {
					
					check = false;
					break;
				}
			}
			
			if (check == true) {
				__groupComplete = true;
				__loading = false;
				dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE, __group));
			}
			
			
		}
		
		protected function checkGroupProgress():void {
			
			var bytesLoaded:uint = 0;
			var bytesTotal:uint = 0;
			
			for (var b in __assets) {
				__tempAsset = __assets[b] as Asset;
				bytesLoaded += __tempAsset.bytesLoaded;
				bytesTotal += __tempAsset.bytesTotal;
			}
			
			dispatchEvent(new AssetProgressEvent(AssetProgressEvent.PROGRESS, bytesLoaded, bytesTotal, __group));
			
		}
		
	
	
	
	
		
		protected function onComplete(e:Event):void {
			
			for (var b in __assets) {
				__tempAsset = __assets[b];
				if (__tempAsset.loaderDispatcher == e.target) {
					break;
				}
			}
			
			//Cleanup
			__tempAsset.loaderDispatcher.removeEventListener(Event.COMPLETE, onComplete);
			__tempAsset.loaderDispatcher.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
			__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
			__tempAsset.loaderSecurityDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			__tempAsset.complete = true;
			
			checkGroupComplete();
		}
		
		protected function onProgress(e:ProgressEvent):void {
			for (var b in __assets) {
				__tempAsset = __assets[b];
				if (__tempAsset.loaderDispatcher == e.target) {
					break;
				}
			}
			
			__tempAsset.bytesLoaded = e.bytesLoaded;
			__tempAsset.bytesTotal = e.bytesTotal;
			
			checkGroupProgress();
		}
		
		protected function onIOError(e:IOErrorEvent):void {
			throw (new Error("[ASSET GROUP " + __group + "] - IOError " + e));
		}
		
		protected function onIONetworkError(e:IOErrorEvent):void {
			throw (new Error("[ASSET GROUP " + __group + "] - IONetworkError " + e));
		}
		
		protected function onIODiskError(e:IOErrorEvent):void {
			throw (new Error("[ASSET GROUP " + __group + "] - IODiskError " + e));
		}
		
		protected function onSecurityError(e:SecurityErrorEvent):void {
			throw (new Error("[ASSET GROUP " + __group + "] - SecurityError " + e));
		}
		
		
		
		
		
		public function clean():void {
			for (var b in __assets) {
				__tempAsset = __assets[b] as Asset;
				__tempAsset.loaderDispatcher.removeEventListener(Event.COMPLETE, onComplete);
				__tempAsset.loaderDispatcher.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, onIONetworkError);
				__tempAsset.loaderDispatcher.removeEventListener(IOErrorEvent.DISK_ERROR, onIODiskError);
				__tempAsset.loaderSecurityDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				try {
					__tempAsset.close();
				}
				catch (ec:Error) {
					//Uncomment if you're interested in seeing this. Otherwise don't worry about it, it will fail silently.
					//trace("[GROUP " + __group + "] - Could Not Close Asset - Most likely because it is already closed");
				}
				try {
					__tempAsset.unload();
				}
				catch (eu:Error) {
					//Uncomment if you're interested in seeing this. Otherwise don't worry about it, it will fail silently.
					//trace("[GROUP " + __group + "] - Could Not Unload Asset - Most likely because it is already unloaded or can't be unloaded");
				}
				__assets[b] = null;
			}

			__assets = null;
			__indexedAssets = null;
			__tempAsset = null;
			__loaderContext = null;
			
		}
		
		
	}
}
