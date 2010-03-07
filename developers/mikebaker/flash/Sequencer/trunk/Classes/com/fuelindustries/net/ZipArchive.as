package com.fuelindustries.net
{
	import com.fuelindustries.events.ZipArchiveEvent;
	import com.nochump.util.zip.ZipEntry;
	import com.nochump.util.zip.ZipFile;

	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	/**
	 * Dispatched when the .zip archive is being downloaded.
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched when the .zip archive has completed downloading
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched when a file from the archive is ready to be displayed
	 */
	[Event(name="fileComplete", type="com.fuelindustries.events.ZipArchiveEvent")]
	
	/**
	 * A class to download and extract zip archives
	 * @example
	 * <pre> 
	 * import com.fuelindustries.net.*;
	 *	import com.fuelindustries.events.*;
	 *	
	 *	var archive:ZipArchive = new ZipArchive();
	 *	archive.addEventListener( "complete", archiveComplete );
	 *	archive.addEventListener( ZipArchiveEvent.FILE_COMPLETE, fileComplete );
	 *	
	 *	archive.load( "http://demo-dev.fuelindustries.com/videos.zip" );
	 *	
	 *	function archiveComplete( event:Event ):void
	 *	{
	 *		archive.loadFile( "test.swf" );
	 *	}
	 *	
	 *	function fileComplete( event:ZipArchiveEvent ):void
	 *	{
	 *		var mc:MovieClip = event.content as MovieClip;
	 *		addChild( mc );
	 *	}
	 * </pre>
	 */
	public class ZipArchive extends EventDispatcher
	{
		private var archive:ZipFile;
		
		public function ZipArchive()
		{
		}
		
		/**
		 * Load the zip archive
		 * @param url The url of the zip archive
		 * @eventType progress Dispatched when data is received as the download operation progresses.
		 * @eventType complete Dispatched after data has loaded successfully.
		 * @eventType securityError A load operation attempted to retrieve data from a server outside the caller's security sandbox. This may be worked around using a policy file on the server. 
		 * @eventType ioError The load operation could not be completed.
		 * @throws Error File is invalid 
		 */
		public function load( url:String ):void
		{
			var urlStream:URLStream = new URLStream();
			urlStream.addEventListener( Event.COMPLETE, completeHandler );
			urlStream.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			urlStream.addEventListener( SecurityErrorEvent.SECURITY_ERROR, errorHandler );
			urlStream.addEventListener( "progress", progressHandler );
			var request:URLRequest = new URLRequest( url );
			
			try
			{
				urlStream.load( request );
			} 
			catch( error:Error )
			{
				trace( error.message );
			}	
		}
		
		/**
		 * Loads a file from the archive so that it can be displayed
		 * @param filename The name of the file in the archive
		 * @eventType com.fuelindustries.events.ZipArchiveEvent.FILE_COMPLETE Dispatched when the content is ready to be displayed.
		 * @throws Error If the file does not exist in the archive
		 */
		public function loadFile( filename:String ):void
		{
			var entry:ZipEntry = archive.getEntry( filename );
			
			if( entry == null )
				throw new Error( "file not in archive" );
			
			var file:ByteArray = archive.getInput( entry );
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener( "complete", fileComplete );
			l.loadBytes( file );	
		}
		
		private function fileComplete( e:Event ):void
		{
			var content:Object = e.target.content;
			e.target.removeEventListener( "complete", fileComplete );
			dispatchEvent( new ZipArchiveEvent( ZipArchiveEvent.FILE_COMPLETE, content ) );
		}
		
		private function progressHandler( event:ProgressEvent ):void
		{
			dispatchEvent( new ProgressEvent( "progress", false, false, event.bytesLoaded, event.bytesTotal ) );
		}
		
		private function completeHandler( event:Event ):void
		{
			var data:URLStream = URLStream( event.target );
			archive = new ZipFile( data );
			dispatchEvent( new Event( "complete" ) );	
		}
		
		private function errorHandler( event:ErrorEvent ):void 
		{
			trace( event );
			dispatchEvent( event.clone() );
		}
	}
}