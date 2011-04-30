package com.breaktrycatch.bitmap 
{

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**	 * @author plemarquand	 */	public class PNGSnapshot 
	{
		private static const EXTENSION : String = ".png";

		public function PNGSnapshot() 
		{
		}

		public function saveSnapshot(target : DisplayObject, filename : String) : void
		{
			var data : BitmapData = takeSnapshot( target );
			saveFile( data, filename );
		}

		public function saveData(data : BitmapData, filename : String) : void
		{
			saveFile( data, filename );
		}

		private function saveFile(data : BitmapData, filename : String) : void
		{
			filename = verifyExtension( filename );
			var imageByteArray : ByteArray = PNGEnc.encode( data );
			var fileRef : FileReference = new FileReference( );
			fileRef.save( imageByteArray, filename );
		}

		private function verifyExtension(filename : String) : String
		{
			if(filename.indexOf( EXTENSION ) != filename.length - EXTENSION.length)
			{
				filename = filename + EXTENSION;
			}
			return filename;
		}

		private function takeSnapshot(target : DisplayObject) : BitmapData
		{
			var data : BitmapData = new BitmapData( target.width, target.height, true );
			data.draw( target );
			return data;
		}	}}