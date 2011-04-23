package com.loadedFontRegister.main.control {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;

	/**
	 * @author Mike
	 */
	public class LoadControl extends MovieClip 
	{
		public var load_btn:MovieClip;
		public var title_txt:TextField;
		public var loadedContainer_mc:MovieClip;
		
		private var __loader:Loader;
		private var __loadedContent:MovieClip;
		private var __path:String;
		private var __overrideAppDomain:Boolean;
		
		public function LoadControl()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			load_btn.addEventListener(MouseEvent.CLICK, onLoadClick);
			load_btn.buttonMode = true;
		}
		
		//setting _overrideAppDomain to true will pass in the current app domain into the loaded content
		public function init(_path:String, _overrideAppDomain:Boolean, title:String):void
		{
			__path = _path;
			__overrideAppDomain = _overrideAppDomain;
			title_txt.text = title;
		}

		private function onLoadClick(e : MouseEvent) : void 
		{
			load_btn.removeEventListener(MouseEvent.CLICK, onLoadClick);
			load_btn.buttonMode = false;
			
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain());
			__loader.load(new URLRequest(__path), context);
		}

		private function onLoaderComplete(e : Event) : void 
		{
			__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			
			//init loaded content
			__loadedContent = MovieClip(__loader.content);
			
			var appDomainOverride:ApplicationDomain = (__overrideAppDomain) ? ApplicationDomain.currentDomain : null;
			__loadedContent.init(appDomainOverride);
			loadedContainer_mc.addChild(__loadedContent.display);
		}
	}
}
