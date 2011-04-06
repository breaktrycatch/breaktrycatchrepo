package com.unloadAndStopExample.main.core {
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import com.unloadAndStopExample.loaded.LoadedClipExample;
	import flash.utils.setTimeout;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Mike
	 */
	public class UnloadAndStopExampleCore extends MovieClip 
	{
		public var unload_btn:MovieClip;
		public var addAndUnload_btn:MovieClip;
		public var load_btn:MovieClip;
		
		private var __loader:Loader;
		private var __loadedClip:DisplayObject;
		
		
		public function UnloadAndStopExampleCore()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			setupButtons();
			hideUnloadButtons();
		}

		private function setupNewLoader():void
		{
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		private function setupButtons():void
		{
			load_btn.addEventListener(MouseEvent.CLICK, onLoadClick);
			load_btn.useHandCursor = true;
			
			unload_btn.addEventListener(MouseEvent.CLICK, onUnloadClick);
			unload_btn.useHandCursor = true;
			
			addAndUnload_btn.addEventListener(MouseEvent.CLICK, onAddAndUnloadClick);
			addAndUnload_btn.useHandCursor = true;
		}

		private function hideUnloadButtons():void
		{
			unload_btn.visible = false;
			addAndUnload_btn.visible = false;
		}

		private function showUnloadButtons():void
		{
			unload_btn.visible = true;
			addAndUnload_btn.visible = true;
		}
		
		private function onLoadClick(event : MouseEvent) : void 
		{
			cleanupOldClip();
			
			setupNewLoader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			__loader.load(new URLRequest("loaded.swf"), context);
		}
		
		private function onLoaderComplete(e : Event) : void 
		{
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			trace("load complete");
			
			createAndShowLoadedContent();
			showUnloadButtons();
		}
		
		private function createAndShowLoadedContent():void
		{
			var clazz:Class = Class(getDefinitionByName("com.unloadAndStopExample.loaded.LoadedClipExample"));
			__loadedClip = new clazz();
			addChild(__loadedClip);
		}
		
		private function onUnloadClick(e : MouseEvent) : void 
		{
			__loader.unloadAndStop();
			__loader = null;
			
			hideUnloadButtons();
		}

		private function onAddAndUnloadClick(e : MouseEvent) : void 
		{
			addChild(__loader);
			__loader.unloadAndStop();
			removeChild(__loader);	
			__loader = null;
			
			hideUnloadButtons();	
		}
		
		private function cleanupOldClip():void
		{
			if(__loadedClip)
			{
				__loadedClip.parent.removeChild(__loadedClip);
				__loadedClip = null;
			}
		}
	}
}
