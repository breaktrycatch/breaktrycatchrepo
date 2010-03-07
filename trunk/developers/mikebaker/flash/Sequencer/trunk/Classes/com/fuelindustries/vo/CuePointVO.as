
package com.fuelindustries.vo 
{
	import com.fuelindustries.utils.NumberUtils;

	/**
	 * @author smulcahy
	 */
	public class CuePointVO {
		
		private var __time:Number;
		private var __name:String;
		
		public function CuePointVO()
		{
		
		}
		/**
		 * Returns void
		 * @param p_string In format hh::mm:ss:ms (00:00:44:00)
		 * Converts the string to a millisecond time format
		 */
		public function setTime(p_string:String):void
		{
		    var newtime:Number = NumberUtils.getMSFromTimestamp(p_string);
			time = newtime;
		}
			/**
		 * Returns void
		 * @param p_string 
		 * Sets the name property of the cuepoint. This is for public consumption
		 */
		public function setName(p_string:String):void
		{
		     name = p_string;
		}
		
		 /**
		 * Returns String
		 * Returns the name property of the object
		 */
		public function get name():String
		{
			return(__name);
		}
		/**
		 * Returns void
		 * @param p_string
		 * Sets the name property 
		 */
		public function set name(p_string:String):void
		{
			__name = p_string;
		}
		
		/**
		 * Returns void
		 * @param p_number 
		 * Sets the time for the value object
		 */
		public function set time(p_number:Number):void
		{
			__time = p_number;
		}
		/**
		 * Returns Number
		 * Returns the time property
		 */
		public function get time():Number
		{
			return(__time);
		}
			/**
		 * Returns String
		 * Prints out the string representation of the CuePointVO object
		 */
		public function toString():String
		{
		   var str:String = "CuePointVO";
		   str+="name "+name;
		   str+="time "+time.toString();
		   return(str);
		}
		
	}
}
