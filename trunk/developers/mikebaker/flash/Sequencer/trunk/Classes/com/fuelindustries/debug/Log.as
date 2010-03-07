package com.fuelindustries.debug
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;

	/**
	* A Logger class that interaces with the FDebug trace window
	*/
	public class Log extends EventDispatcher
	{
		
		private static var serverName:String = "_FDEBUGWIN";
		private static var inited:Boolean = false;
		private static var __lc:LocalConnection;
			
		/**
		* Sends output to the trace window and FDebug Window
		* @param msg The output value to debug
		*/
		public static function debug( msg:Object, ...args:Array ):void
		{
			var message:String = msg + " " + args.join( " " );
			
			sendMessage( message );
			trace( message );
		}
		
		/**
		* Sends an object dump to the trace window and FDebug Window
		* @param obj The object to debug
		*/
		public static function debugObject( obj:Object ):void
		{
			var msg:String = traceObject( obj, null, null );
			sendMessage( msg );
			trace( msg );
		}
		
		/**
		 * Generates a stack trace without throwing an error.
		 * Useful for supplementing log entries with more debug information.
		 * @return A stack trace with the calling function on the top of the stack.
		 */
		public static function getStackTrace() : String
		{
			// trunkates the full class file paths so things are easier to read.
			var stackTrace : String = new Error().getStackTrace().replace(/\[[A-Z]\:\\[A-Za-z\\ ]+Classes/g, "^");
			var stackLines : Array = stackTrace.split("\n");
			
			stackLines.shift(); // Removes "Error at.."
			stackLines.shift(); // Remvoes this function from the stack
			
			// longest line length, used for line padding.
			var longest : int = String( stackLines.concat().sort(sortOnStringLength)[0]).indexOf("^") + 5;
			for ( var i : Number = stackLines.length - 1; i >= 0; i-- ) 
			{
				stackLines[i] = String( stackLines[i] ).replace("^", multiply(" ", longest - String( stackLines[i] ).indexOf("^")));
			}
			
			return stackLines.join("\n");
		}
		
		private static function initConnection():void
		{
			__lc = new LocalConnection();
			__lc.addEventListener( StatusEvent.STATUS, lcstatus );
			inited = true;
		}
		
		private static function lcstatus( event:StatusEvent ):void
		{
			//trace( event );
		}
		
		private static function sendMessage( msg:Object ):void
		{
			
			if( !inited ) initConnection();
			if( Capabilities.playerType != "External" )
			{
				__lc.send( serverName, "trace", msg );
			}
		}
		
		private static function traceObject( obj:Object, s:String, t:String, event:Boolean = false ):String
		{
			if( t == null ) t = "    ";
			else t += "    ";
			if( s == null ) s = "Object: {";
			else s += "{";
			
			for( var p:Object in obj )
			{
				s += "\n"+t;
				if ( obj[p] is Array )
				{
					s += traceObject( obj[p], p+":Array ", t);
				}
				else if (typeof obj[p] == "object" ) 
				{
					if( event )
					{
						if( p != "target" )
						{
							s += traceObject( obj[p], p+":Object ", t );
						}
					}
					else
					{
						s += traceObject( obj[p], p+":Object ", t );
					}
				}
				else if (typeof obj[p]  == "function")
				{
					s += p+": (function)";
				}
				else 
				{
					s += p+": "+obj[p];
				}
			}
			return s+"\n"+t.slice(0,-1)+"}";
		}
		
		private static function sortOnStringLength(a:String, b:String):int
		{
			return (a.indexOf("^") > b.indexOf("^")) ? (-1) : ((b.indexOf("^") > a.indexOf("^")) ? (1) : (0)); 
		}

		private static function multiply( str : String, n : Number ) : String 
		{
			var ret : String = "";
			for( var i : Number = 0;i < n; i++ ) ret += str;
			return ret;
		}
	}
}