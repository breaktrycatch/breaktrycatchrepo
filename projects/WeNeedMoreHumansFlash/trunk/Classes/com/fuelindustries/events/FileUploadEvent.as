package com.fuelindustries.events
{
	import flash.events.Event;
	import flash.net.FileReference;

	/**
	 * The FileUploadEvent is used in conjunction with the FileUploader class.
	 */
	public class FileUploadEvent extends Event 
	{
		public static const FILE_UPLOADING 			: String = "fileUploading";
		public static const FILE_UPLOADED 			: String = "fileUploaded";
		public static const ALL_FILES_UPLOADED 		: String = "allFilesUploaded";
		
		public static const FILE_DOWNLOADING		: String = "fileDownloading";
		public static const FILE_DOWNLOADED			: String = "fileDownloaded";
		public static const ALL_FILES_DOWNLOADED	: String = "allFilesDownloaded";
		
		public static const PROGRESS				: String = "fileProgressEvt";
		
		public static const FILESIZE_ERROR	 		: String = "filesizeError";
		public static const UPLOAD_ERROR			: String = "uploadError";
		public static const MULTIPLE_FILES_ERROR	: String = "multipleFilesError";
		
		public var message 			: String;
		public var file 			: FileReference;
		public var downloadedFiles	: Array;
		
		public var totalFiles 		: int;
		public var currentFile 		: int;
		public var loadedPercent 	: Number;

		public function FileUploadEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			return new FileUploadEvent( type, bubbles, cancelable );
		}
	}
}
