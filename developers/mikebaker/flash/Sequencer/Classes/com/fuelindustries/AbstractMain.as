package com.fuelindustries
{
	//testing some 1 line comments
		/////////a line comment
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * Abstract Main Class to be extended and used as the base main class.
	 * By default it removes the default items from the context menu.
	 * Adds the users Flash Player Version to the context menu
	 * Adds the BuildNumber.BUILD_NUMBER to the context menu. This can be set up to get the svn revision number.
	*/
	public class AbstractMain extends MovieClip
	{
		public function AbstractMain()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		protected function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		    initStageDefaults();
		    initContextMenuDefaults();
		}
		
		/**
		 * Inits the Stage Defaults and can be overridden
		 */
		protected function initStageDefaults():void
		{
			if(this.stage!=null)
			{
		    	this.stage.align = StageAlign.TOP_LEFT;
		    	this.stage.scaleMode = StageScaleMode.NO_SCALE;
		    	this.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * Inits the Context Menu Defaults and can be overridden;
		 * Adds Flash Player Version to the context menu
		 * Adds the Build Number to the context menu
		 */
		protected function initContextMenuDefaults():void
		{
		    var menu : ContextMenu = new ContextMenu();
		    menu.hideBuiltInItems();
		    
		    var versionitem:ContextMenuItem = new ContextMenuItem( getFlashPlayerVersion() );
            menu.customItems.push(versionitem);
            
            var builditem:ContextMenuItem = new ContextMenuItem( "Build - " + BuildNumber.BUILD_NUMBER );
            menu.customItems.push( builditem );
            
		    this.contextMenu = menu;
		}
		
		
		private function getFlashPlayerVersion() : String
		{
			return( "FP Version - " + Capabilities.version );	
		}
	}
}