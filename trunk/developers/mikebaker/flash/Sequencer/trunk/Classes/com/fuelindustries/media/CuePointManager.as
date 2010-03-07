package com.fuelindustries.media 
{
	import com.fuelindustries.events.CuePointEvent;
	import com.fuelindustries.utils.ArrayUtils;
	import com.fuelindustries.vo.CuePointVO;

	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author smulcahy
	*/
	public class CuePointManager extends EventDispatcher {
		
		private static var TIME_DELAY:int=50;
		private var __dataProvider:Array;
		private var __times:Array;
		private var __source:Object;
		private var __timer:Timer;
		private var __time:Number;
		private var __isSwf:Boolean;
		
		public function CuePointManager(target : IEventDispatcher = null) {
			super(target);
			 __timer = new Timer(TIME_DELAY,0);
			 __timer.addEventListener(TimerEvent.TIMER,onTick);
			 __source = null;
		}
		/**
		 * Sets the dataProvider which is an array of com.fuelindustries.util.CuePointVO objects
		 * @param array The array of cue point value objects
		 */
		public function set dataProvider(p_array:Array):void
		{
			__dataProvider = p_array;
			__times = new Array();
			var len:Number = __dataProvider.length;
			for(var i:Number = 0;i<len;i++)
			{
				__times.push(__dataProvider[i].time);
			}
		}
		
		/**
		 * Retruns an Array - array of com.fuelindustries.util.CuePointVO objects
		 * @param void
		 * @return An Array of com.fuelindustries.media.CuePointVO objects
		 */
		public function get dataProvider():Array
		{
			return(__dataProvider);
		}
		
		/**
		 * Returns a com.fuelindustries.media.CuePointVO
		 * @param p_index A number within the dataProvider range
		 * @return An object of com.fuelindustries.media.CuePointVO type
		 */
		public function getItemAt(p_index:Number):CuePointVO
		{
			return(__dataProvider[p_index]);
		}
		/**
		 * Returns void
		 * @param p_file An object that can be of Sound,Video types
		 * Sets the source which can be used to check against the duration of the source
		 * as opposed to using the timers time. Handy if you may pause the video , etc
		 */
		public function set source(p_file:*):void
		{
		    __source = p_file;
			if(__source is MovieClip)
			{
				__isSwf = true;
				__source.addEventListener(CuePointEvent.CUEPOINT,onSwfCuePoint);
			}
		}
		/**
		 * Returns Object
		 * @return An object of that is specifed as the source to check against for duration
		  * */
		public function get source():Object
		{
		   return(__source);
		}
		/**
		 * Returns void
		 * Starts the CuePointManager monitoring process
		 */
		public function start():void
		{
		    __time = 0;
		    __timer.start();
		}
		/**
		 * Returns void
		 * Stops the cue point checking process. Used if you want to "pause"
		 */
		public function stop():void
		{
			__timer.stop();
		}
		/**
		 * Returns void
		 * Resets the timer and associated values.Used if you want to reset
		 */
		public function reset():void
		{
			stop();
			__time = 0;
			
		}
		/**
		 * Returns void
		 * Destroys the cuepoint manager from continuing, does cleanup
		 * Removes listeners if they exist
		 * TODO - needs to be tested
		 */
		public function destroy():void
		{
			if(__isSwf && __source!=null)
			{
				__source.removeEventListener(CuePointEvent.CUEPOINT,onSwfCuePoint);
				__isSwf = false;
			}
			 __timer.removeEventListener(TimerEvent.TIMER,onTick);
			
		}
			/**
		 * Returns void
		 * @param p_evt Paramater of TimerEvent type 
		 * Method to handle the timer TimerEvent.TIMER event. Checks the cue point on each call.
		 */
		private function onTick(p_evt:TimerEvent):void
		{
		   __time+=TIME_DELAY;
		   var time:Number = (source!=null)?source.position : __time;
		   trace(source.position);
		   checkForCuePoint(time);
		}
		
		/**
		 * Returns void
		 * @param p_time Number of time in milliseconds
		 * Checks the dataProvider for the cuepoints. If one is without the TIME_DELAY, it gets fired.
		 * TO DO: might need to have further "has fired" checking, etc. 
		 */
		private function checkForCuePoint(p_time:Number):void
		{
             var index:Number = ArrayUtils.findNearest(p_time,__times);
             if(Math.abs(__dataProvider[index].time - p_time) <TIME_DELAY){
		       var cuePoint:CuePointVO = __dataProvider[index] as CuePointVO;
		       sendCuePoint(cuePoint);
             }
		}
		/**
		 * Called by a swf - with a cuepoint event dispatched
		 * @param p_event CuePointEvent to check against
		 * Broadcasts the cue point event with the cue point value object that matches the name value
		 */
		private function onSwfCuePoint(p_event:CuePointEvent):void
		{
			var vo:CuePointVO = p_event.data as CuePointVO;
			var name:String = vo.name;
			callCueByName(name);
			
		}
			/**
		 * Returns void
		 * @param p_vo CuePointVO value object
		 * Broadcasts the cue point event with the cue point value object
		 */
		private function sendCuePoint(p_vo:CuePointVO):void
		{
			var event:CuePointEvent = new CuePointEvent(p_vo);
			dispatchEvent(event);
		}
		/**
		 * Call a cue point by the index
		 * @param p_index Index number to pull from the dataprovider array
		 * Broadcasts the cue point event with the cue point value object that matches the index number
		 */
		
		public function callCueByIndex(p_index:Number):void
		{
			if(p_index <0 || p_index > __dataProvider.length-1)
			{
				return;
			}
			var vo:CuePointVO = __dataProvider[p_index] as CuePointVO;
			sendCuePoint(vo);
			
		}
		/**
		 * Call a cue point by name outside 
		 * @param p_string String to check against
		 * Broadcasts the cue point event with the cue point value object that matches the string value
		 */
		
		public function callCueByName(p_string:String):void
		{
			var vo:CuePointVO = getCueByName(p_string);
			sendCuePoint(vo);
		}
		/**
		 * Utility function get pull the proper cue poitn by the name
		 * @param p_string String to check against
		 * Returns a CuePointVO 
		 * 
		 */
		private function getCueByName(p_string:String):CuePointVO
		{
			var len:Number = __dataProvider.length;
			for(var i:Number =0;i<len;i++)
			{
				var vo:CuePointVO = __dataProvider[i] as CuePointVO;
				if(vo.name == p_string)
				{
					return(vo);
				}
			}
			return( new CuePointVO());
		}

}
}
