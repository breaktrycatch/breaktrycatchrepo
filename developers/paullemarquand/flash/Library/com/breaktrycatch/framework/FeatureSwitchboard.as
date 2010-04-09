package com.breaktrycatch.framework
{
	import flash.utils.Dictionary;
	
	public class FeatureSwitchboard 
	{
		public static const NONE : int = -1;
		public static const LOCAL : int = 0;
		public static const DEV : int = 1;
		public static const STAGE : int = 2;
		public static const LIVE : int = 3;
		
		private static var CURRENT_SERVER : int = NONE;
		
		private static var _servers : Dictionary;
		
		/**
		* Sets the current runtime environment. Use stage.loaderInfo.url to get
		* the url of the current swf dynamically.
		* 
		* @param rootURL The url of the current swf.
		*/
		public static function setEnvironment(rootURL : String) : void
		{
			for (var name : String in _servers) 
			{
				if(new RegExp(name).test(rootURL))
				{
					CURRENT_SERVER = _servers[name];
				}
			}
			
			if(CURRENT_SERVER == NONE)
			{
				throw new ArgumentError("Unknown server! Halting execution.");
			}
		}
		
		/**
		* Adds a server to the list of allowed servers the application can
		* run on. The server identifier doesn't necessarily have to be the 
		* whole server name (http://www.foobar.com/baz/flash) but can instead 
		* be a portion of the domain (foobar.com or just foobar).
		* 
		* @param name The identifier of the server (either full or partial url)
		* @param level The level of the server. The higher the level, the more
		* restrictive the feature set.
		*/
		public static function addServer(id : String, permissionLevel : int) : void
		{
			if(!_servers)
			{
				_servers = new Dictionary();
				_servers["file://"] = LOCAL;
			}
			
			_servers[id] = permissionLevel;
		}
		
		/**
		* Given a feature's permission level this method will return true
		* if the feature is permitted on this server. Features are usually kept
		* in a group of static variables and would be used like:
		* <code>
		* if(FeatureSwitchboard.isFeatureEnabled(Features.AWESOME_FEATURE))
		* {
		* 	// execute or show awesome feature.
		* }
		* </code>
		* @param feature The feature's permission level.
		* @return if that feature is enabled.  
		*/
		public static function isFeatureEnabled(feature : int) : Boolean
		{
			return CURRENT_SERVER <= feature;
		}

		/**
		* Returns true if the level passed in is equal to the current level.
		* @param environment The level of the server (ie. FeatureSwitchboard.DEV).
		* @return If the permission level of the server is equal to the current permission level.
		*/
		public static function currentEnvironment(environment : int) : Boolean
		{
			return CURRENT_SERVER == environment;
		}
		
		/**
		* Returns true of the swf is running locally.
		*/
		public static function get DEBUG_MODE() : Boolean
		{
			return CURRENT_SERVER == LOCAL;
		}
	}
}
