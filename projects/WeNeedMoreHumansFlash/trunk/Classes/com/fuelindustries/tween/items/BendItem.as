package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IPosition;

	import flash.geom.Point;

	/** @private */
	public class BendItem extends MotionItem implements IMotionItem
	{
		private var __controlx:Number;
		private var __controly:Number;
		private var __anchorx:Number;
		private var __anchory:Number;
		private var __startx:int;
		private var __starty:int;
		private var __mc:IPosition;
		
		public function get mc():IPosition
		{
			return( __mc );	
		}

		public function BendItem( mc:IPosition, cx:Number, cy:Number, ax:Number, ay:Number, duration:int, ease:String, callback:Function, callbackArgs:Array )
		{
			super(  duration, ease, callback, callbackArgs );
			__mc = mc;
			__controlx = cx;
			__controly = cy;
			__anchorx = ax;
			__anchory = ay;
			__startx = mc.x;
			__starty = mc.y;
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
			var percent:Number = __easeFunction( timePassed/1000, 0, 1, __duration/1000  );
			
			var p0:Point = new Point( __startx, __starty );
			var p1:Point = new Point(__anchorx, __anchory );
			var p2:Point = new Point(__controlx, __controly );
		
			var t:Number = percent;

			var t1:Number = (1 - t);
			var t1_2:Number = (t1 * t1);
			var t2:Number = (t * t);
			var tt12:Number = ((2 * t) * t1);
			var x:Number = (((t1_2 * p0.x) + (tt12 * p1.x)) + (t2 * p2.x));
			var y:Number = (((t1_2 * p0.y) + (tt12 * p1.y)) + (t2 * p2.y));
			
			__mc.x = x;
			__mc.y = y;
			
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
			__mc.x = __controlx;
			__mc.y = __controly;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}