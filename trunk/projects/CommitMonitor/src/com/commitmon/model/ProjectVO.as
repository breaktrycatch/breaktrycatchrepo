package com.commitmon.model
{
	import com.commitmon.controller.MonitorLogHandler;
	import com.commitmon.controller.SVNMonitorClient;
	import com.commitmon.controller.notification.NotificationDispatcher;
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;

	[RemoteClass]
	public class ProjectVO extends EventDispatcher
	{
		[Bindable]
		public var revisions : ArrayCollection;
		
		[Bindable]
		public var totalUnchecked : int;
		
		[Bindable]
		public var maxEntries : int = 50;
		
		[Bindable]
		public var pollTimeInMinutes : int = 1;
		
		[Bindable]
		public var name : String;
		
		[Bindable]
		public var svnURL : String;
		
		[Bindable]
		public var username : String;
		
		[Bindable]
		public var password : String;
		
		private var _log : MonitorLogHandler;
		private var _watchers : Dictionary;
		private var _firstUpdate : Boolean = true;
		
		public function get log():ISVNLogEntryHandler
		{
			return _log;
		}
		
		public function ProjectVO()
		{
			revisions = new ArrayCollection();
			_watchers = new Dictionary();
			_log = new MonitorLogHandler(this);
			
			ChangeWatcher.watch(this, 'maxEntries', onMaxEntriesUpdated);
		}
		
		private function onMaxEntriesUpdated(event:PropertyChangeEvent):void
		{
			cullOldEntries();
		}
		
		public function update(client : SVNMonitorClient):void
		{
			client.addEventListener(Event.COMPLETE, function(e:Event):void {
				client.removeEventListener(Event.COMPLETE, arguments.callee);
				populate(_log.updateComplete());
				dispatchEvent(e.clone());
			});
			client.getLog(_log, (revisions.length == 0) ? (maxEntries) : (30));
		}
		
		public function populate(items : ArrayCollection):void
		{
			var newItems : ArrayCollection = new ArrayCollection();
			items.source.forEach(function(item:CommitMonitorLogEntry,...args):void {
				
				if(_firstUpdate)
				{
					item.viewed = true;
				}
				
				if(!item.viewed)
				{
					totalUnchecked++;
					_watchers[item] = ChangeWatcher.watch(item, 'viewed', onItemViewed);
					newItems.addItem(item);
				}
			});
			
			_firstUpdate = false;
			revisions.addAllAt(items, 0);
			cullOldEntries();
			
			if(newItems.length)
			{
				NotificationDispatcher.getInstance().dispatchNotification(newItems, this);
			}
		}
		
		private function cullOldEntries():void
		{
			// remove the ones at the bottom of the list...
			while(revisions.length > maxEntries)
			{
				revisions.removeItemAt(revisions.length - 1);
			}
		}
		
		public function markAllAsViewed():void
		{
			revisions.source.forEach(function(item:CommitMonitorLogEntry, ...args):void {
				item.viewed = true;
			});
		}
		
		private function onItemViewed(e:PropertyChangeEvent):void
		{
			if(e.newValue)
			{
				var watcher : ChangeWatcher = _watchers[e.target];
				watcher.unwatch();
				
				totalUnchecked--;
			}
			trace("Item viewed!!! Left unchecked: " + totalUnchecked);
		}
	}
}