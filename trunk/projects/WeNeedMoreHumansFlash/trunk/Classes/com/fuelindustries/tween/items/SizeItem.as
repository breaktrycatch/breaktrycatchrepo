package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.ISize;

	/** @private */
	public class SizeItem extends MotionItem implements IMotionItem
	{
		private var __destw : Number;
		private var __desth : Number;
		private var __startw : Number;
		private var __starth : Number;
		private var __mc:ISize;
		
		public function get mc():ISize
		{
			return( __mc );	
		}
		
		
		public function SizeItem( mc : ISize, ew : Number, eh : Number, duration : int, ease : String, callback : Function, callbackArgs : Array )
		{
			super( duration, ease, callback, callbackArgs);
			__mc = mc;
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

			var neww:Number = __easeFunction( timePassed / 1000, __startw, __destw - __startw, __duration / 1000 );
			__mc.width = Math.round( neww );

			var newh:Number = __easeFunction( timePassed / 1000, __starth, __desth - __starth, __duration / 1000 );
			__mc.height = Math.round( newh );

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

			__mc.height = __desth;
			__mc.width = __destw;

			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}