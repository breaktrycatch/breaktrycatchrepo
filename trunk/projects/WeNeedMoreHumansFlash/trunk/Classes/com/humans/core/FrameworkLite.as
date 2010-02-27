package com.humans.core {
	import caurina.transitions.Tweener;

	import com.fuelindustries.AbstractMain;
	import com.fuelindustries.net.assetmanager.core.AssetManager;
	import com.fuelindustries.net.assetmanager.events.AssetCompleteEvent;
	import com.fuelindustries.net.assetmanager.events.AssetProgressEvent;
	import com.fuelindustries.net.assetmanager.statics.AssetStatics;
	import com.humans.data.statics.AppStatics;
	import com.humans.data.statics.PreloaderStatics;
	import com.humans.data.statics.ProjectStatics;
	import com.humans.ui.preloader.PreloaderUI;
	import com.module_tracer.core.TraceManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Capabilities;

	/**
	 * @author jkeon
	 */
	public class FrameworkLite extends AbstractMain {
		
		//Reference to the asset manager
		protected var __assetManager:AssetManager;
		//Reference to the core
		protected var __frameworkCore:IFrameworkCore;
		
		//Preloader
		public var preloader_mc:MovieClip;
		protected var __preloaderUI:PreloaderUI;
		
		public function FrameworkLite() {
			super();
		}

		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			
			//Setup the Preloader
			__preloaderUI = new PreloaderUI();
			__preloaderUI.setDisplayByClip(preloader_mc);
			
			//Hides those annoying yellow rectangles on stage focus change
			this.stage.stageFocusRect = false;
			
			//Get the AssetManager
			__assetManager = AssetManager.getInstance();
			
			//Configure the Statics
			configureStatics( );
			autoStatics();
			//Configure the Assets to load
			configureAssets( );
			autoAssets();
		}
		
		//Configures your statics. Override to set your own default values
		protected function configureStatics() : void 
		{
			//Setting all default values
			ProjectStatics.setStatic( "urlassets", "../" );
			ProjectStatics.setStatic( "swf_url", "" );
			ProjectStatics.setStatic( "image_url", "../images/" );
		}
		
		//Automatically pulls in all statics and sets the Debug and Live Mode
		protected function autoStatics():void {
			//Get Flash Vars
			var params : Object = root.loaderInfo.parameters;
			//Overwrites any default vars with vars passed in from html
			for (var name:String in params) 
			{
				ProjectStatics.setStatic( name, params[name] );
			}
				
			if (Capabilities.playerType == "External") {
				AppStatics.DEBUG_MODE = true;
				TraceManager.LIVE_MODE = false;
			}
			else {
				TraceManager.LIVE_MODE = true;
				TraceManager.DEPLOYED_DEBUG_TRACE = true;
				AppStatics.DEBUG_MODE = false;
			}
		}
		
		//Configures which assets to load for preload. Override to add your own
		protected function configureAssets() : void 
		{
			//CORE
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "framework_core.swf", AssetStatics.GROUP_PRELOADER );
			
			//VIEWS
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "view_gallery.swf", AssetStatics.GROUP_PRELOADER );
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "view_towerGallery.swf", AssetStatics.GROUP_PRELOADER );	
		}
		
		//Automatically loads the assets configured
		protected function autoAssets():void {
			__assetManager.addEventListener( AssetCompleteEvent.COMPLETE, onPreloadComplete );
			__assetManager.addEventListener( AssetProgressEvent.PROGRESS, onPreloadProgress );
			
			__assetManager.loadGroup(AssetStatics.GROUP_PRELOADER, !AppStatics.DEBUG_MODE);
		}
		
		//When progress is returned
		protected function onPreloadProgress(e:AssetProgressEvent):void {
			if (e.group == AssetStatics.GROUP_PRELOADER) {
				//Updated the UI
				__preloaderUI.updatePercentage(e.bytesLoaded/e.bytesTotal);
			}
		}
		
		//When completed
		protected function onPreloadComplete(e:AssetCompleteEvent):void {
			if (e.group == AssetStatics.GROUP_PRELOADER) {
				__assetManager.removeEventListener( AssetCompleteEvent.COMPLETE, onPreloadComplete );
				__assetManager.removeEventListener( AssetProgressEvent.PROGRESS, onPreloadProgress );
				//animate out
				constructCore();
				fadePreloader();
			}
		}
		
		//Constructs the core
		protected function constructCore():void { 
			//Construct the Core
			__frameworkCore = __assetManager.getAsset(PreloaderStatics.FRAMEWORKCORE_CLASSPATH);
		}
		
		//Fades the preloader
		protected function fadePreloader():void {
	
			//Fade the Preloader
			Tweener.addTween(__preloaderUI, {alpha:0, time:1.0, onComplete:addCore});
		}
		
		//Adds the core to the stage
		protected function addCore():void {
			removeChild(preloader_mc);
			__preloaderUI.destroy();
			__preloaderUI = null;
			this.addChild(__frameworkCore.display);
		}
	}
}
