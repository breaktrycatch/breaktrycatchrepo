package com.util
{

	import com.breaktrycatch.bitmap.PNGEnc;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author plemarquand
	 */
	public class FileUtil
	{
		public static function getUniqueFilenamePrepend() : String
		{
			var date : Date = new Date();
			var time : String = date.toLocaleTimeString().replace( /:/g, "_" ).replace( / /g, "_" );
			var day : String = date.toDateString().replace( / /g, "_" );
			return day + "_" + time + "_";
		}

		public static function saveUniquePNG(_source : BitmapData, _name : String) : void
		{
			var filename : String = FileUtil.getUniqueFilenamePrepend() + _name;
			var fl : File = File.desktopDirectory.resolvePath( filename );
			var fs : FileStream = new FileStream();
			try
			{
				fs.open( fl, FileMode.WRITE );
				fs.writeBytes( PNGEnc.encode( _source ) );
				fs.close();
			}
			catch(e : Error)
			{
				trace( e.message );
			}
		}
	}
}
