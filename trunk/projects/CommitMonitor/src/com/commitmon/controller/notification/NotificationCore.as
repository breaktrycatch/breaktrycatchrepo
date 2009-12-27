package com.commitmon.controller.notification
{
	import com.commitmon.controller.SVNMonitorClient;
	import com.commitmon.controller.event.NotificationProcessEvent;
	import com.commitmon.model.ApplicationState;
	import com.commitmon.model.ProjectVO;
	import com.fuelindustries.util.ArrayExtensions;
	import com.fuelindustries.util.DictionaryExtensions;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class NotificationCore extends EventDispatcher
	{
		private var _client : SVNMonitorClient;
		private var _projects : ArrayCollection;
		private var _updateQueue : Array;
		private var _timeoutHashTable : Dictionary;
		private var _updating : Boolean = false;
		
		private static const MILLIS_PER_MINUTE : int = 60000;
		
		public function NotificationCore(settings : ApplicationState)
		{
			_projects = settings.projects;
			_projects.addEventListener(CollectionEvent.COLLECTION_CHANGE, onProjectListUpdated);
			
			configurePolls();
		}
		
		private function configurePolls() : void
		{
			_updateQueue = new Array();
			_timeoutHashTable = new Dictionary();
			_client = new SVNMonitorClient();
			_updateQueue = _projects.source.concat();
			
			nextInQueue();
		}
		
		public function checkForUpdates(vo:ProjectVO):void
		{
			if(_updateQueue.length)
			{
				_updateQueue.push(vo);
			}
			else
			{
				updateProject(vo);
			}
		}
		
		private function nextInQueue() : void
		{
			if(_updateQueue.length)
			{
				updateProject(_updateQueue.shift());
			}
			else
			{
				dispatchEvent(new NotificationProcessEvent(NotificationProcessEvent.REFRESH_COMPLETE));
			}
		}
		
		private function createTimeout(vo : ProjectVO) : void
		{
			_timeoutHashTable[vo] = setTimeout(updateProject, vo.pollTimeInMinutes * MILLIS_PER_MINUTE, vo);
		}
		
		private function updateProject(vo : ProjectVO) : void 
		{
			if(_updating)
			{
				trace("------------- Already updating... Queueing " + vo.name + " -------------------");
				_updateQueue.push(vo);
				return;
			}
			trace("------------- UPDATING " + vo.name + " -------------------");
			
			dispatchEvent(new NotificationProcessEvent(NotificationProcessEvent.REFRESH_STARTED));
			_updating = true;
			
			var completeFn : Function = function(e:Event):void { 
				_client.removeEventListener(Event.CONNECT, arguments.callee);
				parseData(vo);
			}
			
			_client.addEventListener(Event.CONNECT, completeFn);
			_client.connect(vo.svnURL, vo.username, vo.password);
		}
		
		private function parseData(vo : ProjectVO):void
		{
			trace("------------ CONNECTED " + vo.name + " -------------------");
			vo.addEventListener(Event.COMPLETE,function(e:Event):void {
				
				trace("------------ COMPLETE " + vo.name + " -------------------");
				vo.removeEventListener(Event.COMPLETE, arguments.callee);
				_updating = false;
				createTimeout(vo);
				nextInQueue();
			});
			vo.update(_client);
		}
		
		private function onProjectListUpdated(event:CollectionEvent):void
		{
			if(event.kind == CollectionEventKind.ADD)
			{
				ArrayExtensions.simpleForEach(event.items, checkForUpdates);
			}
		}
		
		public function clear() : void
		{
			DictionaryExtensions.forEach(_timeoutHashTable, function(item : int, ...args):void {
				clearTimeout(item);
			});
			DictionaryExtensions.clear(_timeoutHashTable);
			_updateQueue = [];
		}
	}
}