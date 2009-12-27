package com.commitmon.model
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class DocumentService
	{
		private static const FILENAME :String = "commitMonSettings.cmon";
		
		public function DocumentService()
		{
		}
		
		public static function load():ApplicationState
		{
			var file:File = File.applicationStorageDirectory.resolvePath(FILENAME);
			
			if(file.exists) 
			{
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				obj = fileStream.readObject();
				fileStream.close();
				return obj as ApplicationState;
			}
			return null;
		}
		
		public static function save(settings : ApplicationState):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(FILENAME);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(settings);
			fileStream.close();
		}
	}
}