package com.unloadAndStopExample.main.core {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
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
		private var __path:String = "loaded.swf";
		
		public function UnloadAndStopExampleCore()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		//init
		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			//in a moderately gross way set an absolute path to the loaded swf
			__path = stage.loaderInfo.url.replace('main.swf', __path);
			
			setupButtons();
			hideUnloadButtons();
		}

		//constructs and sets up a new loader instance
		private function setupNewLoader():void
		{
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		//Adds event listeners to buttons and makes them feel more buttony
		private function setupButtons():void
		{
			load_btn.addEventListener(MouseEvent.CLICK, onLoadClick);
			load_btn.buttonMode = true;
			
			unload_btn.addEventListener(MouseEvent.CLICK, onUnloadClick);
			unload_btn.buttonMode = true;
			
			addAndUnload_btn.addEventListener(MouseEvent.CLICK, onAddAndUnloadClick);
			addAndUnload_btn.buttonMode = true;
		}

		//Hides the unload buttons when a clip isn't ready to be unloaded
		private function hideUnloadButtons():void
		{
			unload_btn.visible = false;
			addAndUnload_btn.visible = false;
		}

		//Shows the unload buttons when a clip is ready to be unloaded 
		private function showUnloadButtons():void
		{
			unload_btn.visible = true;
			addAndUnload_btn.visible = true;
		}
		
		//remove the visual of the old clip and load a new one
		private function onLoadClick(event : MouseEvent) : void 
		{
			cleanupOldClip();
			
			setupNewLoader();
			
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			__loader.load(new URLRequest(__path), context);
		}
		
		//When the load is complete instantiate the loaded clip and show the unload buttons
		private function onLoaderComplete(e : Event) : void 
		{
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			trace("load complete");
			
			createAndShowLoadedContent();
			showUnloadButtons();
		}
		
		//isntantiate the loaded clip
		private function createAndShowLoadedContent():void
		{
			var clazz:Class = Class(getDefinitionByName("com.unloadAndStopExample.loaded.LoadedClipExample"));
			__loadedClip = new clazz();
			addChild(__loadedClip);
		}
		
		//Just call unloadAndStop
		private function onUnloadClick(e : MouseEvent) : void 
		{
			__loader.unloadAndStop();
			__loader = null;
			
			hideUnloadButtons();
		}

		//Call unload and stup once the loader is on the stage
		private function onAddAndUnloadClick(e : MouseEvent) : void 
		{
			addChild(__loader);
			__loader.unloadAndStop();
			removeChild(__loader);	
			__loader = null;
			
			hideUnloadButtons();	
		}
		
		//Makes sure the visual of the old clip is off the stage
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
