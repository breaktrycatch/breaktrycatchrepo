package com.commitmon.controller.notification
{
	import com.commitmon.controller.event.NotificationEvent;
	import com.commitmon.model.ProjectVO;
	import com.commitmon.util.PlatformUtil;
	import com.commitmon.view.event.ViewChangeEvent;
	import com.commitmon.view.notification.BaseNotification;
	import com.commitmon.view.notification.CommitNotification;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Window;

	public class NotificationDispatcher extends EventDispatcher
	{
		public static var instance :  NotificationDispatcher;
		
		private static const HEIGHT_MARGIN : int = 5;
		private var _notificationQueue : Array;
		
		public static function getInstance() :  NotificationDispatcher
		{
			if( instance == null ) instance = new NotificationDispatcher( new SingletonEnforcer( ) );
			return instance;
		}
		
		public function NotificationDispatcher( pvt : SingletonEnforcer )
		{
			_notificationQueue = [];
		}
		
		public function closeAll():void
		{
			_notificationQueue.forEach(function(item : Window, ...args):void{
				item.close();
			});
		}
		
		public function dispatchNotification(revisions : ArrayCollection, project : ProjectVO) : void
		{
			if(revisions.length > 0)
			{
				var window : BaseNotification = createNotification(CommitNotification);
				window.project = project;
				window.data = revisions;
				window.nativeWindow.y = getOSWindowPosition(window);
				window.addEventListener(Event.CLOSE, onWindowClosed);
				_notificationQueue.push(window);
				
				var evt : NotificationEvent = new NotificationEvent(NotificationEvent.REVISIONS_RECIEVED);
				evt.revisions = revisions;
				evt.project = project;
				dispatchEvent(evt);
			}
		}
		
		private function getOSWindowPosition(window : Window):int
		{
			var os : String = Capabilities.os.toLowerCase();
			var windowHeight : Number;
			var lastY : Number;
			
			// open from the top
			if(PlatformUtil.USER_OS == PlatformUtil.MAC)
			{
				windowHeight = (_notificationQueue.length) ? (_notificationQueue[_notificationQueue.length - 1].height) : (window.height);
				lastY = (_notificationQueue.length) ? (_notificationQueue[_notificationQueue.length - 1].nativeWindow.y) : (25 - windowHeight);
				return lastY + windowHeight;
			}
			else // open from the bottom.
			{
				var taskbarHeight : Number = Screen.mainScreen.bounds.height - Screen.mainScreen.visibleBounds.height;
				
				lastY = (_notificationQueue.length) ? (_notificationQueue[_notificationQueue.length - 1].nativeWindow.y) : (Capabilities.screenResolutionY - taskbarHeight);
				windowHeight = window.height;
				return lastY - windowHeight;
			}
		}
		
		private function createNotification(type : Class) : BaseNotification
		{
			var window : BaseNotification = new type();
			window.width = 210;
			window.open(true);
			window.addEventListener(ViewChangeEvent.CHANGE_VIEW, onNotificationClicked, false, 0, true);
			return window;
		}
		
		private function onNotificationClicked(event:ViewChangeEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onWindowClosed(event:Event):void
		{
			var index : int = _notificationQueue.indexOf(event.target);
			_notificationQueue.splice(index, 1);
		}
	}
}

internal class SingletonEnforcer {}