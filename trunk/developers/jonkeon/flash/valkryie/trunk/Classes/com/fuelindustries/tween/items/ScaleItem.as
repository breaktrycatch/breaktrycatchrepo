package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	/** @private */
	public class ScaleItem extends MotionItem implements IMotionItem
	{
		private var __destx:*;
		private var __desty:*;
		private var __startx:Number;
		private var __starty:Number;

		public function ScaleItem( mc : AssetProxy, ex:*, ey:*, duration:int, ease:*, callback:Function, callbackArgs:Array )
		{
			super( mc, duration, ease, callback, callbackArgs );
			__destx = ex/100;
			__desty = ey/100;
			__startx = mc.scaleX;
			__starty = mc.scaleY;
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
			var mc:AssetProxy = __mc as AssetProxy;
				
			if( __destx != null || __destx != undefined )
			{
				mc.scaleX = __easeFunction( timePassed/1000, __startx, __destx - __startx, __duration/1000 );
			}
			
			if( __desty != null || __desty != undefined )
			{
				mc.scaleY = __easeFunction( timePassed/1000, __starty, __desty - __starty, __duration/1000 );
			}
			
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
			
			if( __desty != null || __desty != undefined )
			{
				mc.scaleY = __desty;
			}
			
			if( __destx != null || __destx != undefined )
			{
				mc.scaleX = __destx;
			}
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}