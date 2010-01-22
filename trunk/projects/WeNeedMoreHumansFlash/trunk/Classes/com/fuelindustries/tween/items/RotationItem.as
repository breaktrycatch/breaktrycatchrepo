package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IRotation;

	/** @private */
	public class RotationItem extends MotionItem implements IMotionItem
	{
		private var __destRotation : Number;
		private var __startRotation : Number;
		private var __mc:IRotation;
		
		public function get mc():IRotation
		{
			return( __mc );	
		}
		
		public function RotationItem( mc : IRotation, rotation : Number, duration : int, ease : String, callback : Function, callbackArgs : Array )
		{
			super( duration, ease, callback, callbackArgs);
			__mc = mc;
			__destRotation = rotation;
			__startRotation = mc.rotation;
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;
			
			var newrotation : Number = __easeFunction(timePassed / 1000, __startRotation, __destRotation - __startRotation, __duration / 1000);
			__mc.rotation = newrotation;
			
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

			__mc.rotation = __destRotation;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}