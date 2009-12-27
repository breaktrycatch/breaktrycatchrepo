package com.fuelindustries.svn.tests 
{
	import com.fuelindustries.parser.AS3Parser;
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.io.svn.SVNRepositoryImpl;
	import com.fuelindustries.svn.events.GetDirEvent;
	import com.fuelindustries.svn.events.GetFileEvent;
	import com.fuelindustries.svn.events.LatestRevisionEvent;
	import com.fuelindustries.svn.events.SVNEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author julian
	 */
	public class SVNTest extends MovieClip 
	{
		
		private var repository:SVNRepositoryImpl;
		
		private var __latestrevision:int;
		
		private var __entries:Array;
		
		public function get entries():Array
		{
			return( __entries );	
		}
		
		public function SVNTest()
		{
			
			var url:SVNURL = SVNURL.parseURIEncoded("svn://10.0.0.9/Flash/CodeLibrary/as3/trunk/Classes");
        	var userName:String = "jdolce";
        	var userPassword:String = "jdolce";
        	
        	repository = new SVNRepositoryImpl( url );
        	repository.addEventListener( SVNEvent.AUTHENTICATED, onAuthenticated );
        	repository.addEventListener( LatestRevisionEvent.LATEST_REVISION, onLatestRevision );
        	repository.addEventListener( GetDirEvent.GET_DIR, onGetDir );
        	repository.addEventListener( GetFileEvent.GET_FILE, onGetFile );
        	repository.connect( userName, userPassword );
		}
		
		private function onGetFile(event:GetFileEvent):void
		{
			trace( "got file", event.path );
			
			AS3Parser.parse(event.contents);

			var path:String = ( event.path.charAt() == "/" ) ? event.path.substring( 1 ) : event.path;

			var f:File = new File( "/Users/julian/Work/Projects/Fuel Internal Projects/SVNBrowser/branches/as3svn/exports/" + path);
			var stream:FileStream = new FileStream();
			stream.open( f , FileMode.WRITE );
			stream.writeBytes( event.contents );
			stream.close();
			
		}

		private function onGetDir( e:GetDirEvent ):void
		{
			var entries:Array = e.entries;			
			__entries = entries;
			
			dispatchEvent( new Event( Event.COMPLETE ) );	
		}
		
		private function onLatestRevision( e:LatestRevisionEvent ):void
		{
			__latestrevision = e.latestRevision;
			trace( "onLatestRevision", e.latestRevision );
			
			//repository.getRevisionProperties(__latestrevision);
			
			getDir("/Flash/CodeLibrary/as3/trunk/Classes/com/fuelindustries/");
			//getDir( "/Flash/Projects/" );
		}
		
		public function getDir( path:String ):void
		{
			trace( "getting dir", path );
			repository.getDir(path, __latestrevision);
		}
		
		public function getFile( path:String ):void
		{
			trace( "getting file", path );
			repository.getFile( path, false, true, __latestrevision );	
		}
		
		private function onAuthenticated( e:Event ):void
		{
			trace( "onAuthenticated" );
			repository.getLatestRevision();
		}
	}
}
