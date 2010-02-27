package com.fuelindustries.net
{
	import com.fuelindustries.events.FileUploadEvent;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * This class is used for uploading either single or multiple files to a server.
	 */
	public class FileUploader extends EventDispatcher
	{
		private var __fileRefList 				: FileReferenceList;
		private var __uploadURL 				: String;
		private var __downloadURL				: String;
		private var __fileFilters 				: Dictionary;
		private var __allowMultiple				: Boolean = false;
		private var __allowDownload				: Boolean = false;
		
		private var __downloadedFiles 			: Array;
		private var __fileArr					: Array;
		private var __currentFile 				: int = 0;
		
		private var FILE_SIZE_LIMIT 			: int = 2500000;
		
		protected const ERROR_GENERIC 			: String = "An error occured while processing your request";
		protected const ERROR_FILESIZE 			: String = "The file is too large. Please select a smaller one";
		protected const ERROR_UPLOADURL 		: String = "uploadURL must be set before calling browse()";
		protected const ERROR_DOWNLOADURL 		: String = "downloadURL must be set before calling browse() if allowDownload is set to true";
		protected const ERROR_MULTIPLE 			: String = "Multiple files selected when allowMultiple = false. Keeping the first file selected, discarding the rest.";
		
		public function FileUploader() 
		{
			__fileFilters = new Dictionary();
		}
		
		/**
		 * <p>Opens a brose dialog and applies the FileFilters already specified.
		 * Once a file is selected the upload process automatically begins.</p>
		 * 
		 * <p>Make sure you have set uploadURL as well as added the appropriate listeners</p>
		 */
		public function browse() : void
		{
			__fileRefList = new FileReferenceList( );  
			__fileRefList.addEventListener( Event.SELECT, onSelect );
			__fileRefList.browse( getValues( __fileFilters ) );
		}
		
		/**
		 * Adds a file filter to the browse dialog. 
		 * File filters determine what filetypes to show.
		 * 
		 * @param fileFilter A FileFilter object with a unique description parameter.
		 */
		public function addFileFilter( fileFilter : FileFilter ) : void
		{
			__fileFilters[ fileFilter.description ] = fileFilter;
		}
		
		/**
		 * Removes a file filter that would be used on the browse dialog.
		 * 
		 * @param fileFilter A FileFilter that has been added via addFileFilter.
		 */
		public function removeFileFilter( fileFilter : FileFilter ) : void
		{
			delete( __fileFilters[ fileFilter.description ] );
		}
		
		/**
		 * Utility function that gets a random integer based off the time/date. 
		 * A quick hack for generating file IDs with a low chance of name collisions.
		 * 
		 * @return A random unique ID
		 */
		public function getRandomPID() : int
		{
			return ( new Date() ).getMilliseconds() + Math.round( Math.random() * 9999999 );
		}
		
		/**
		 * Sets the URL that the FileUploader calls to upload the file to. 
		 * A dynamic script should reside at this URL that handles the upload.
		 * 
		 * @param url The URL to upload files to.
		 */
		public function set uploadURL( url : String ) : void
		{
			__uploadURL = url;
		}
		
		public function get uploadURL() : String
		{
			return __uploadURL;
		}
		
		/**
		 * Sets the directory that the FileUploader calls to download the files its uploaded from.
		 * 
		 * Note: This only needs to be set is allowDownload is set to true.
		 * 
		 * @param url The URL to download files from.
		 */
		public function set downloadURL( url : String ) : void
		{
			__downloadURL = url;
		}
		
		public function get downloadURL() : String
		{
			return __downloadURL;
		}
		
		/**
		 * A boolean value that determines whether or not multiple files uploads are allowed.
		 * If this is set to false and the user selects multiple files, we keep the first one selected,
		 * dispatch a FileUploadEvent.MULTIPLE_FILES_ERROR, and discard the rest of the selected files.
		 * 
		 * @param b A boolean that indicates whether or not multiple file uploads are allowed.
		 */
		public function set allowMultiple( b : Boolean ) : void
		{
			__allowMultiple = b;
		}
		
		public function get allowMultiple() : Boolean
		{
			return __allowMultiple;
		}
		
		/**
		 * A boolean value that determines if we should download the files back into Flash Player
		 * after we have uploaded them. This is useful when we want to use user content in games.
		 * 
		 * @param b A boolean that indicates whether or not to download the files 
		 * 			back into Flash Player after they've been uploaded.
		 */
		public function set allowDownload( b : Boolean ) : void
		{
			__allowDownload = b;
		}
		
		public function get allowDownload() : Boolean
		{
			return __allowDownload;
		}
		
		/**
		 * An array of the files that have been downloaded. This can be called at any point and 
		 * will return the files downloaded so far. You will most likely have to cast the array
		 * elements when you pull them out since they are dumped into the array using the .content
		 * property of a LoaderInfo object.
		 * 
		 * @return An array of downloaded objects.
		 */
		public function get downloadedFiles() : Array
		{
			return __downloadedFiles;
		}
		
		/**
		 * Sets the maximum size in bytes that a file can be, i.e. 2500000 is approx 2.5MB. 
		 * If the user uploads a file larger than the limit, a FileUploadEvent.FILESIZE_ERROR
		 * event is dispatched and the file is not uploaded.
		 * 
		 * @param limit Maximum size in bytes the uploaded file can be.
		 */
		public function set fileSizeLimit( limit : int ) : void
		{
			FILE_SIZE_LIMIT = limit;	
		}
		
		public function get fileSizeLimit() : int
		{
			return FILE_SIZE_LIMIT;
		}
		
		/*
		 * Uploads a single file to the specified uploadURL and calls
		 * onFileUploaded when the upload is succcessful.
		 */
		private function uploadFile( file : FileReference ) : void
		{
			var request : URLRequest = new URLRequest( __uploadURL ); 
			
			file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onFileUploaded );
			file.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				 
			try
			{
				var uploadEvt : FileUploadEvent = new FileUploadEvent( FileUploadEvent.FILE_UPLOADING );
				uploadEvt.file = file;
				dispatchEvent( uploadEvt );
				
				file.addEventListener( ProgressEvent.PROGRESS, onUploadProgress );
				
				file.upload( request ); 
			}
			catch( err : Error )
			{
				var errorEvt : FileUploadEvent = getEvent( FileUploadEvent.UPLOAD_ERROR );
				errorEvt.file = file;
				errorEvt.message = ERROR_GENERIC;
				dispatchEvent( errorEvt );
			}
		}
		
		/*
		 * Downloads a file from the server and dispatches a 
		 * FileUploadEvent.FILE_DOWNLOADING to let you know.
		 */
		private function downloadFile( fileRef : FileReference ) : void
		{
			var url 	: String = fileRef.name;
			var request : URLRequest;
			
			// if the download url is a file rather than a folder...
			if( fileTypeInUrl( __downloadURL ) )
				request = new URLRequest( __downloadURL );
			else
				request = new URLRequest( __downloadURL + url );
			
			var loader 	: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onFileDownloaded );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			loader.load( request );
			
			var evt : FileUploadEvent = getEvent( FileUploadEvent.FILE_DOWNLOADING );
			evt.file = __fileArr[ __currentFile ];
			dispatchEvent( evt );	
		}
		
		/*
		 * Checks to see if the url points to a filetype 
		 * that is contained in one of the FileFilters.
		 * 
		 * NOTE: This wont work unless its a url that links directly to the image.
		 * 		 It cannot be used on urls to scripts that return an image.
		 */
		private function fileTypeInUrl( url : String ) : Boolean
		{
			for (var i : String in __fileFilters ) 
			{
				var filter 		: FileFilter = __fileFilters[ i ];
				var extensions 	: Array = filter.extension.split( ";" );
				var len			: int = extensions.length;
				for ( var j 	: int = 0; j < len; j++ ) 
				{
					var ext : String = String( extensions[ j ] ).replace( "*", "" );
					
					// if the last few letters are the extension this url points to the file
					if( url.indexOf( ext, url.length - ext.length ) != -1 )
						return true;
				}
			}
			
			return false;	
		}
		
		/*
		 * Dispacthes what is basically a custom progress event with more relevent properties.
		 */
		private function onUploadProgress( e : ProgressEvent ) : void
		{
			var evt : FileUploadEvent = getEvent( FileUploadEvent.PROGRESS );
			evt.loadedPercent = e.bytesLoaded / e.bytesTotal;
			dispatchEvent( evt );
		}
		
		/*
		 * Ensures that the selected file is smaller than the max size and broadcasts
		 * an event if it is not. Also ensures that the uploadURL has been set and throws
		 * a runtime error if it is not, since you cannot continue. 
		 * 
		 * Returns true if all is well.
		 */
		private function errorCheck( files : Array ) : Boolean
		{
			// if no URL is set we throw a runtime error because we cant continue.
			if( !__uploadURL )
			{
				throw new Error( ERROR_UPLOADURL );
				return false;
			}
			
			// if no download url is specified and we're planning on downloading when we're done uploading,
			// we set the download url to the upload url and assume the file has not been moved.
			if( !__downloadURL &&  __allowDownload )
			{
				__downloadURL = __uploadURL;
			}
			
			// if allowMultiple is false and the user has selected multiple files, 
			// we dispatch a MULTIPLE_FILES_ERROR and chop the array down to only the first element.
			if( !__allowMultiple && files.length > 1 )
			{
				var errorEvt : FileUploadEvent = new FileUploadEvent( FileUploadEvent.MULTIPLE_FILES_ERROR );
				errorEvt.message = ERROR_MULTIPLE;
				dispatchEvent( errorEvt );
				
				files = files.slice( 0, 1 );
			}
			
			// if any one of the files is too big we dispatch an error and remove the file from the queue.
			var file 	: FileReference; 
			var len 	: int = files.length;
			for (var i 	: Number = 0; i < len; i++) 
			{
				file = files[ i ];
				if( file.size > FILE_SIZE_LIMIT )
				{
					var fileEvt : FileUploadEvent = getEvent( FileUploadEvent.FILESIZE_ERROR );
					fileEvt.currentFile = i;
					fileEvt.file = file;
					fileEvt.message = ERROR_FILESIZE;
					dispatchEvent( fileEvt );
					
					files.splice( i, 1 );
					
					// if we've removed the only element in the array, we cant continue.
					if( files.length == 0 )
						return false;
				}
			}
			
			return true;
		}
		
		/*
		 * Called when the user hits OK on the browse dialog.
		 */
		private function onSelect( e : Event ) : void
		{
			__fileRefList.removeEventListener( Event.SELECT, onSelect );
			__fileArr = FileReferenceList( e.target ).fileList;
			__downloadedFiles = new Array();
			
			if( !errorCheck( __fileArr ) )
				return;
			else
				uploadFile( __fileArr[ 0 ] );
		}
		
		/*
		 * Once the file has been uploaded we need to download it back from the server
		 * into the swf.
		 */
		private function onFileUploaded( e : Event ) : void
		{
			FileReference( e.target ).removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onFileUploaded );
			FileReference( e.target ).removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			FileReference( e.target ).removeEventListener( ProgressEvent.PROGRESS, onUploadProgress );
			
			var evt : FileUploadEvent = new FileUploadEvent( FileUploadEvent.FILE_UPLOADED );
			evt.file = __fileArr[ __currentFile ];
			dispatchEvent( evt );
			
			__currentFile++;
			
			if( __currentFile >= __fileArr.length )
				onAllFilesUploaded();
			else
				uploadFile( __fileArr[ __currentFile ] );
		}
		
		/*
		 * Called when all the files have finished uploading. If allowDownload is set to true then
		 * we start downloading those files back in.
		 */
		private function onAllFilesUploaded( e : FileUploadEvent = null ) : void
		{
			dispatchEvent( new FileUploadEvent( FileUploadEvent.ALL_FILES_UPLOADED ) );
			
			__currentFile = 0;
			
			if( __allowDownload )
				downloadFile( __fileArr[ __currentFile ] );
		}
		
		/*
		 * Adds the file to the __downloadedFiles array 
		 * and dispatches a FILE_DOWNLOADED event.
		 */
		private function onFileDownloaded( e : Event ) : void
		{
			LoaderInfo( e.target ).removeEventListener( Event.COMPLETE, onFileDownloaded );
			LoaderInfo( e.target ).removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			__downloadedFiles.push( LoaderInfo( e.target ).content );
			
			var evt : FileUploadEvent = new FileUploadEvent( FileUploadEvent.FILE_DOWNLOADED );
			evt.file = __fileArr[ __currentFile ];
			evt.downloadedFiles = __downloadedFiles;
			dispatchEvent( evt );
			
			__currentFile++;
			
			if( __currentFile >= __fileArr.length )
				onAllFilesDownloaded();
			else
				downloadFile( __fileArr[ __currentFile ] );
		}
		
		/*
		 * Final event handler is called when all files have been downloaded.
		 */
		private function onAllFilesDownloaded( e : FileUploadEvent = null ) : void
		{
			var evt : FileUploadEvent = getEvent( FileUploadEvent.ALL_FILES_DOWNLOADED );
			evt.downloadedFiles = __downloadedFiles;
			dispatchEvent( evt );
			
			__currentFile = 0;
		}
		
		/*
		 * Dispatched when the upload fails for any reason.
		 */
		private function onIOError( e : IOErrorEvent ) : void
		{
			LoaderInfo( e.target ).removeEventListener( Event.COMPLETE, onFileDownloaded );
			LoaderInfo( e.target ).removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			FileReference( e.target ).removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onFileUploaded );
			FileReference( e.target ).removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			FileReference( e.target ).removeEventListener( ProgressEvent.PROGRESS, onUploadProgress );
			
			var errorEvt : FileUploadEvent = getEvent( FileUploadEvent.UPLOAD_ERROR );
			errorEvt.file = __fileArr[ __currentFile ];
			errorEvt.message = ERROR_GENERIC;
			dispatchEvent( errorEvt );
		}
		
		/*
		 * Utility function that returns an event with preset properties 
		 * to keep from having to set them every time.
		 */
		private function getEvent( type : String ) : FileUploadEvent
		{
			var evt : FileUploadEvent = new FileUploadEvent( type );
			evt.totalFiles = __fileArr.length - 1;
			evt.currentFile = __currentFile;
			return evt;
		}
		
		/*
		 * Utility function that converts Dictionary objects to Arrays. 
		 * This is used for FileFilters.
		 * 
		 * Function taken from Adobe's com.adobe.utils.DictionaryUtil
		 * to avoid importing a 3rd party class.
		 */
		private function getValues( d : Dictionary ) : Array
		{
			var a : Array = new Array();
			
			for each ( var value : Object in d )
			{
				a.push(value);
			}
			
			return a;
		}
		
		/*
		 * Quick hack to make useWeakReference = true the default for this class.
		 */
		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );	
		}
	}
}
