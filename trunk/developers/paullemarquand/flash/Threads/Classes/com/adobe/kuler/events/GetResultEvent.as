package com.adobe.kuler.events 
{
	import com.adobe.kuler.swatches.Swatches;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetResultEvent extends Event 
	{
		public static const GET_RESULTS:String = "getResult";
		
		private var _swatches:Swatches;
		private var _numOfResulsts:int;
		
		public function GetResultEvent(numOfResults:int, swatches:Swatches, type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_numOfResulsts = numOfResults;
			_swatches = swatches;
			
		} 
		
		public override function clone():Event 
		{ 
			return new GetResultEvent(_numOfResulsts, _swatches, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GetResultEvent", "numOfResulsts", "results", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get results():Swatches { return _swatches; }
		
		public function get numOfResulsts():int { return _numOfResulsts; }
		
	}
	
}