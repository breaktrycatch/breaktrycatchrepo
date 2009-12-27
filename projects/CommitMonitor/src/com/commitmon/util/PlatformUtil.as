package com.commitmon.util
{
	import flash.system.Capabilities;

	public class PlatformUtil
	{
		private static function determineOS() : String
		{
			var os : String = Capabilities.os.toLowerCase();
			if(os.indexOf("mac") != -1)
			{
				return MAC;
			}
			else if(os.indexOf("linux") != -1)
			{
				return LINUX;
			}
			else if(os.indexOf("windows") != -1)
			{
				return WINDOWS;
			}
			else
			{
				return UNKNOWN;
			}
		}
		
		public static var USER_OS : String = determineOS();
		public static const MAC : String = "mac";
		public static const WINDOWS : String = "windows";
		public static const LINUX : String = "linux";
		public static const UNKNOWN : String = "unknown";
		
	}
}