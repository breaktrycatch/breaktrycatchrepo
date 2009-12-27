package com.commitmon.controller
{
	import com.commitmon.model.ChangedItemEntry;
	import com.commitmon.model.ChangedItemKind;
	import com.commitmon.model.CommitMonitorLogEntry;
	import com.commitmon.model.ProjectVO;
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNLogEntry;
	import com.fuelindustries.svn.core.SVNLogEntryPath;
	import com.fuelindustries.util.DictionaryExtensions;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class MonitorLogHandler implements ISVNLogEntryHandler
	{
		[Bindable]
		public var data : ArrayCollection;
		
		private var _tempList : ArrayCollection;
		private var _revisionHash : Dictionary;
		private var _parentProject : ProjectVO;
		
		public function MonitorLogHandler(parentProject : ProjectVO)
		{
			_parentProject = parentProject;
			_tempList = new ArrayCollection();
			_revisionHash = new Dictionary();
			data = new ArrayCollection();
		}
		
		public function handleLogEntry(logEntry:SVNLogEntry):void
		{
			//TODO: Move storage of models to the ProjectVO and only have the handler deal with creation
			if(!_revisionHash[logEntry.getRevision()])
			{
				var model : CommitMonitorLogEntry = new CommitMonitorLogEntry();
				model.revision = logEntry.getRevision();
				model.author = logEntry.getAuthor();
				model.message = logEntry.getMessage();
				model.date = logEntry.getDate().getDate();
				model.changedItems = createChangedItemEntries(logEntry.getChangedPaths().items());
				_tempList.addItem(model);
				
				_revisionHash[model.revision] = true;
			}
		}
		
		private function createChangedItemEntries(dict : Dictionary) : Dictionary
		{
			// we need to map the SVNLogEntryPaths in this dict in to our own model so that they are serializable.
			return DictionaryExtensions.map(dict, function(item : SVNLogEntryPath, ...args):ChangedItemEntry
			{
				var itemEntry : ChangedItemEntry = new ChangedItemEntry();
				itemEntry.path = item.myPath;
				itemEntry.type = item.myType;
				itemEntry.copyPath = item.myCopyPath;
				itemEntry.copyRevision = item.myCopyRevision;
				itemEntry.nodeKind = new ChangedItemKind(item.myNodeKind.myID);
				return itemEntry;
			});
		}
		
		public function updateComplete() : ArrayCollection	
		{
			var toReturn : ArrayCollection = new ArrayCollection(_tempList.source.concat());
			_tempList = new ArrayCollection();
			return toReturn;
		}
		
		public function manualTestAdd(entries : Array):void
		{
			data.addAll(new ArrayCollection(entries));
		}
	}
}