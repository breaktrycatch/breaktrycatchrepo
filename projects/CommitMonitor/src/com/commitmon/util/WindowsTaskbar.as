package com.commitmon.util
{
	import com.commitmon.controller.event.NotificationEvent;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class WindowsTaskbar extends EventDispatcher
	{
		private var _app : NativeApplication;
		private var _savedWindow : NativeWindow;
		private var _taskbarIcon : BitmapAsset;
		private var _activeIcons : Array;
		private var _docked : Boolean;
		private var _active : Boolean;
		private var _animTimer : Timer;
		private var _timePerFrame : int;
		
		public function WindowsTaskbar(app : NativeApplication, taskbarIcon : BitmapAsset)
		{
			_app = app;
			_taskbarIcon = taskbarIcon;
			
			prepareForSystray();
		}
		
		public function setActiveIcons(icons : Array, timePerFrame : int = 33):void
		{
			_timePerFrame = timePerFrame;
			_activeIcons = icons;
		}
		
		
		public function dock():void 
		{
			_docked = true;
			
			//Hide the applcation
			_savedWindow = _app.activeWindow;
			_app.activeWindow.visible = false;
			
			if(_active && _activeIcons)
			{
				startActiveAnimation();
			}
			else
			{
				//Setting the bitmaps array will show the application icon in the systray
				_app.icon.bitmaps = [_taskbarIcon];
			}
		}
		
		private function undock(event : Event):void
		{
			//After setting the window to visible, make sure that the application is ordered to the front, //else we'll still need to click on the application on the taskbar to make it visible
			_savedWindow.visible = true;
			_savedWindow.orderToFront();
			
			//Clearing the bitmaps array also clears the applcation icon from the systray
			_app.icon.bitmaps = [];
		}
		
		private function createSystrayRootMenu():NativeMenu
		{
			//Add the menuitems with the corresponding actions 
			var menu:NativeMenu = new NativeMenu();
			var openNativeMenuItem:NativeMenuItem = new NativeMenuItem("Open " + CommitMonitor.APPLICATION_NAME);
			var refreshNativeMenuItem:NativeMenuItem = new NativeMenuItem("Check for Updates");
			var closeNativeMenuItem:NativeMenuItem = new NativeMenuItem("Close");
			
			//What should happen when the user clicks on something...       
			
			openNativeMenuItem.addEventListener(Event.SELECT, undock);
			refreshNativeMenuItem.addEventListener(Event.SELECT, onRefresh);
			closeNativeMenuItem.addEventListener(Event.SELECT, onClose);
			
			//Add the menuitems to the menu 
			menu.addItem(openNativeMenuItem);
			menu.addItem(refreshNativeMenuItem);
			menu.addItem(closeNativeMenuItem);
			
			return menu;
		}
		
		private function onRefresh(event:Event):void
		{
			dispatchEvent(new NotificationEvent(NotificationEvent.REFRESH));
		}
		
		private function onClose(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * Check to see if the application may be docked and set basic properties
		 *
		 * @Author: S.Radovanovic
		 */
		public function prepareForSystray():void 
		{ 
			//For windows systems we can set the systray props       
			//(there's also an implementation for mac's, it's similar and you can find it on the net... ;) ) 
			if (NativeApplication.supportsSystemTrayIcon )
			{
				setSystemTrayProperties();
				
				//Set some systray menu options, so that the user can right-click and access functionality          
				//without needing to open the application
				
				SystemTrayIcon(_app.icon).menu = createSystrayRootMenu();
			}
		}
		
		private function setSystemTrayProperties():void
		{
			//Text to show when hovering of the docked application icon       
			SystemTrayIcon(_app.icon).tooltip = CommitMonitor.APPLICATION_NAME;
			
			//We want to be able to open the application after it has been docked       
			SystemTrayIcon(_app.icon).addEventListener(MouseEvent.CLICK, undock);
		}
		
		private function nwMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void 
		{
			//Do we have an minimize action?
			//The afterDisplayState hasn't happened yet, but only describes the state the window will go to,
			//so we can prevent it! 
			if(displayStateEvent.afterDisplayState == NativeWindowDisplayState.MINIMIZED) 
			{
				//Prevent the windowedapplication minimize action from happening and implement our own minimize
				//The reason the windowedapplication minimize action is caught, is that if active we're not able to          //undock the application back neatly. The application doesn't become visible directly, but only after clicking          //on the taskbars application link. (Not sure yet what happens exactly with standard minimize) 
				displayStateEvent.preventDefault();
				
				//Dock (our own minimize) 
				dock();
			}
		}
		
		private function startActiveAnimation():void
		{
			if(_animTimer)
			{
				_animTimer.stop();
				_animTimer = null;
			}
			_animTimer = new Timer(_timePerFrame);
			_animTimer.addEventListener(TimerEvent.TIMER, onTimerUpdate);
			_animTimer.start();
		}
		
		private function onTimerUpdate(event:TimerEvent):void
		{
			//TODO: Implement tray notification animations.
		}
		
		private function stopActiveAnimation():void
		{
			_animTimer.removeEventListener(TimerEvent.TIMER, onTimerUpdate);
			_animTimer.stop();
		}
		
	}
}