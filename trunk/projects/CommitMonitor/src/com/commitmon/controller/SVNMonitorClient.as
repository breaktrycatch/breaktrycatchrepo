package com.commitmon.controller
{
	import com.fuelindustries.svn.client.RepositoryData;
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNRevisionProperty;
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.io.svn.SVNRepositoryImpl;
	import com.fuelindustries.svn.events.LatestRevisionEvent;
	import com.fuelindustries.svn.events.LogEvent;
	import com.fuelindustries.svn.events.SVNEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SVNMonitorClient extends EventDispatcher
	{
		protected var repository:SVNRepositoryImpl;
		protected var __data:RepositoryData;
		
		public function SVNMonitorClient()
		{
			super();
		}
		
		public function connect( url:String, username:String, password:String ):void
		{
			repository = new SVNRepositoryImpl( SVNURL.parseURIEncoded( url ) );
			repository.addEventListener( SVNEvent.AUTHENTICATED, onAuthenticated );
			repository.addEventListener( LatestRevisionEvent.LATEST_REVISION, onLatestRevision );
			repository.addEventListener( LogEvent.LOG, onLogComplete );
			repository.connect( username, password );	
		}
		
		
		private function onAuthenticated( e:Event ):void
		{
			__data = new RepositoryData( repository.getLocation().getPath() );
			repository.getLatestRevision();
		}
		
		private function onLatestRevision( e:LatestRevisionEvent ):void
		{
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		public function getLog( handler : ISVNLogEntryHandler, numRevisions : int = 30 ):void
		{
			repository.log( __data.rootPath, repository.latestRevision, 0, true, false, numRevisions, false, [SVNRevisionProperty.AUTHOR, SVNRevisionProperty.DATE,SVNRevisionProperty.LOG], handler);
		}
		
		private function onLogComplete(e:Event):void
		{
			trace("Log Complete!");
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}