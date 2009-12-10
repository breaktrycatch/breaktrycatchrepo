package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	/** @private */
	public class RotationItem extends MotionItem implements IMotionItem
	{
		private var __destRotation : int;
		private var __startRotation : Number;

		public function RotationItem( mc : AssetProxy, rotation : int, duration : int, ease : *, callback : Function, callbackArgs : Array )
		{
			super(mc, duration, ease, callback, callbackArgs);
			__destRotation = rotation;
			__startRotation = mc.rotation;
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;
			var mc : AssetProxy = __mc as AssetProxy;
			var newrotation : int = __easeFunction(timePassed / 1000, __startRotation, __destRotation - __startRotation, __duration / 1000);
			mc.rotation = newrotation;
			
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
			mc.rotation = __destRotation;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}