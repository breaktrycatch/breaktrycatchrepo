package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	/** @private */
	public class AlphaItem extends MotionItem implements IMotionItem
	{
		private var __destAlpha:int;
		private var __startAlpha:Number;

		public function AlphaItem( mc:AssetProxy, alpha:int, duration:int, ease:*, callback:Function, callbackArgs:Array )
		{
			super( mc, duration, ease, callback, callbackArgs );
			__destAlpha = alpha;
			__startAlpha = mc.alpha * 100;
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			
			var mc:AssetProxy = __mc as AssetProxy;
			
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;

			var newalpha:Number = __easeFunction( timePassed/1000, __startAlpha, __destAlpha - __startAlpha, __duration/1000 );
			mc.alpha =  newalpha / 100;
			
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
			var mc:AssetProxy = __mc as AssetProxy;
			mc.alpha = __destAlpha / 100;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}