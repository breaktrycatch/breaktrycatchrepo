package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.ITween;

	/** @private */
	public class TweenItem extends MotionItem implements IMotionItem
	{
		private var __startValues:Array;
		private var __endValues:Array;
		private var __mc:ITween;
		
		public function get mc():ITween
		{
			return( __mc );	
		}
		
		
		public function TweenItem( mc:ITween, start:Array, end:Array, duration:int, ease:String, callback:Function, callbackArgs:Array )
		{
			super( duration, ease, callback, callbackArgs );
			__mc = mc;
			__startValues = start;
			__endValues = end;
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
			
			var returnArray:Array = [];
			
			for( var i:int = 0; i<__startValues.length; i++ )
			{
				var startval:* = __startValues[ i ];
				var endval:* = __endValues[ i ];
				var val:* = __easeFunction( timePassed/1000, startval, endval - startval, __duration/1000 );
				returnArray.push( val );
			}
			
			__mc.onTweenUpdate.apply( __mc, returnArray );
			
			__currenttime = currentTime;
			
			if( __currenttime >= __endtime ) 
			{
				completed = true;
				tweenComplete();
			}
			
			return( completed );
		}
		
		public override function tweenComplete():void
		{
			var diffTime:int = __currenttime - __endtime;
			__mc.onTweenUpdate.apply( __mc, __endValues );
			__timeDiff = diffTime;
			//executeCallback( );
		}
	}
}