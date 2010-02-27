package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IScale;

	/** @private */
	public class ScaleItem extends MotionItem implements IMotionItem
	{
		private var __destx:Number;
		private var __desty:Number;
		private var __startx:Number;
		private var __starty:Number;
		private var __mc:IScale;
		
		public function get mc():IScale
		{
			return( __mc );	
		}

		public function ScaleItem( mc : IScale, ex:int, ey:int, duration:int, ease:String, callback:Function, callbackArgs:Array )
		{
			super( duration, ease, callback, callbackArgs );
			__mc = mc;
			__destx = ex/100;
			__desty = ey/100;
			__startx = __mc.scaleX;
			__starty = __mc.scaleY;
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
	

			__mc.scaleX = __easeFunction( timePassed / 1000, __startx, __destx - __startx, __duration / 1000 );
			__mc.scaleY = __easeFunction( timePassed / 1000, __starty, __desty - __starty, __duration / 1000 );

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

			__mc.scaleY = __desty;
			__mc.scaleX = __destx;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}