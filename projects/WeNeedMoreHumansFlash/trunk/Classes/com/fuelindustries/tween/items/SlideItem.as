package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IPosition;

	/** @private */
	public class SlideItem extends MotionItem implements IMotionItem
	{
		private var __destx : int;
		private var __desty : int;
		private var __startx : int;
		private var __starty : int;
		private var __mc:IPosition;
		
		public function get mc():IPosition
		{
			return( __mc );	
		}

		public function SlideItem( mc : IPosition, ex : int, ey : int, duration : int, ease : String, callback : Function, callbackArgs : Array )
		{
			super( duration, ease, callback, callbackArgs);
			__mc = mc;
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

			var newx:int = __easeFunction( timePassed / 1000, __startx, __destx - __startx, __duration / 1000 );
			__mc.x = Math.floor( newx );

			var newy:int = __easeFunction( timePassed / 1000, __starty, __desty - __starty, __duration / 1000 );
			__mc.y = Math.floor( newy );

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

			__mc.y = __desty;
			__mc.x = __destx;

			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}