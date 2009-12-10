package com.valkryie.core {
	import com.fuelindustries.AbstractMain;
	import com.module_assets.events.AssetCompleteEvent;
	import com.module_assets.events.AssetProgressEvent;
	import com.module_assets.net.AssetManager;
	import com.module_assets.statics.AssetStatics;
	import com.module_tracer.core.TraceManager;
	import com.valkryie.data.statics.AppStatics;
	import com.valkryie.data.statics.ProjectStatics;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class FrameworkLite extends AbstractMain {
		
		protected var __assetManager:AssetManager;
		
		protected var __frameworkCore:IFrameworkCore;
		private const FRAMEWORKCORE_CLASSPATH:String = "com.valkryie.core.FrameworkCore";
		
		public function FrameworkLite() {
			super();
			__assetManager = AssetManager.getInstance();
		}
		
		protected override function onAdded(e:Event) : void 
		{
			super.onAdded(e);
			//Hides those annoying yellow rectangles on stage focus change
			this.stage.stageFocusRect = false;
			
			//Configure the Statics
			configureStatics( );
			//Configure the Assets to load
			configureAssets( );
		}
		
		protected function configureStatics() : void 
		{
			//Setting all default values
			ProjectStatics.setStatic( "urlassets", "../" );
			ProjectStatics.setStatic( "swf_url", "" );
			
			//Get Flash Vars
			var params : Object = root.loaderInfo.parameters;
			//Overwrites any default vars with vars passed in from html
			for (var name:String in params) 
			{
				ProjectStatics.setStatic( name, params[name] );
			}
				
			
			if (ProjectStatics.getStatic( "urlassets" ) == "../" ) 
			{
				AppStatics.DEBUG_MODE = true;
			} 
			else {
				TraceManager.LIVE_MODE = true;
				TraceManager.DEPLOYED_DEBUG_TRACE = true;
				AppStatics.DEBUG_MODE = false;
			}
		}
		
		protected function configureAssets() : void 
		{
			
			//CORE
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "framework_core.swf", AssetStatics.GROUP_PRELOADER );
			
			//VIEW
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "view_sandbox.swf", AssetStatics.GROUP_PRELOADER );
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "view_editor.swf", AssetStatics.GROUP_PRELOADER );
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "view_particlestest.swf", AssetStatics.GROUP_PRELOADER );
			
			//MODALS
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "modal_create_level.swf", AssetStatics.GROUP_PRELOADER );
			
			//LIBRARY
			__assetManager.addAsset( ProjectStatics.getStatic( "swf_url" ) + "library_textures.swf", AssetStatics.GROUP_PRELOADER );

			
			__assetManager.addEventListener( AssetCompleteEvent.COMPLETE, onPreloadComplete );
			__assetManager.addEventListener( AssetProgressEvent.PROGRESS, onPreloadProgress );
			
			__assetManager.loadGroup(AssetStatics.GROUP_PRELOADER, !AppStatics.DEBUG_MODE);
		}
		
		protected function onPreloadProgress(e:AssetProgressEvent):void {
			if (e.group == AssetStatics.GROUP_PRELOADER) {
				trace(e.bytesLoaded / e.bytesTotal);
			}
		}
		
		protected function onPreloadComplete(e:AssetCompleteEvent):void {
			if (e.group == AssetStatics.GROUP_PRELOADER) {
				__assetManager.removeEventListener( AssetCompleteEvent.COMPLETE, onPreloadComplete );
				__assetManager.removeEventListener( AssetProgressEvent.PROGRESS, onPreloadProgress );
				fadePreloader();
			}
		}
		
		protected function fadePreloader():void {

			
			__frameworkCore = __assetManager.getAsset(FRAMEWORKCORE_CLASSPATH);
	
			addCore();
		}
		
		protected function addCore():void {
			this.addChild(__frameworkCore.display);
		}
	}
}
