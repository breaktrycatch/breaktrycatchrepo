package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	/** @private */
	public class SlideItem extends MotionItem implements IMotionItem
	{
		private var __destx : *;
		private var __desty : *;
		private var __startx : int;
		private var __starty : int;

		public function SlideItem( mc : AssetProxy, ex : *, ey : *, duration : int, ease : *, callback : Function, callbackArgs : Array )
		{
			super(mc, duration, ease, callback, callbackArgs);
			__destx = ex;
			__desty = ey;
			__startx = Math.round(mc.x);
			__starty = Math.round(mc.y);
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;
			
			var mc : AssetProxy = __mc as AssetProxy;
			
			if( __destx != null || __destx != undefined )
			{
				var newx : int = __easeFunction(timePassed / 1000, __startx, __destx - __startx, __duration / 1000);
				mc.x = Math.floor(newx);
			}
			
			if( __desty != null || __desty != undefined )
			{
				var newy : int = __easeFunction(timePassed / 1000, __starty, __desty - __starty, __duration / 1000);
				mc.y = Math.floor(newy);
			}
			
			__currenttime = currentTime;
			
			if( __currenttime >= __endtime ) 
			{
				
				completed = true;
				tweenComplete();
			}
			
			return( completed );
		}

		public override function tweenComplete() : void
		{
			var diffTime : int = __currenttime - __endtime;
			var mc : AssetProxy = __mc as AssetProxy;
			
			if( __desty != null || __desty != undefined )
			{
				mc.y = __desty;
			}
			
			if( __destx != null || __destx != undefined )
			{
				mc.x = __destx;
			}
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}