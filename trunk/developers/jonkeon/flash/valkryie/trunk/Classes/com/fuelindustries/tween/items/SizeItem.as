package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	/** @private */
	public class SizeItem extends MotionItem implements IMotionItem
	{
		private var __destw : *;
		private var __desth : *;
		private var __startw : int;
		private var __starth : int;

		public function SizeItem( mc : AssetProxy, ew : *, eh : *, duration : int, ease : *, callback : Function, callbackArgs : Array )
		{
			super(mc, duration, ease, callback, callbackArgs);
			__destw = ew;
			__desth = eh;
			__startw = Math.round(mc.width);
			__starth = Math.round(mc.height);
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;
			var mc : AssetProxy = __mc as AssetProxy;	
			
			if( __destw != null || __destw != undefined )
			{
				var neww : Number = __easeFunction(timePassed / 1000, __startw, __destw - __startw, __duration / 1000);
				mc.width = Math.round(neww);
			}
			
			if( __desth != null || __desth != undefined )
			{
				var newh : Number = __easeFunction(timePassed / 1000, __starth, __desth - __starth, __duration / 1000);
				mc.height = Math.round(newh);
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
			
			if( __desth != null || __desth != undefined )
			{
				mc.height = __desth;
			}
			
			if( __destw != null || __destw != undefined )
			{
				mc.width = __destw;
			}
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}