package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	import flash.geom.Point;

	/** @private */
	public class BendItem extends MotionItem implements IMotionItem
	{
		private var __controlx:*;
		private var __controly:*;
		private var __anchorx:*;
		private var __anchory:*;
		private var __startx:int;
		private var __starty:int;

		public function BendItem( mc:AssetProxy, cx:*, cy:*, ax:*, ay:*, duration:int, ease:*, callback:Function, callbackArgs:Array )
		{
			super( mc, duration, ease, callback, callbackArgs );
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
			var mc:AssetProxy = __mc as AssetProxy;
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
			
			mc.x = x;
			mc.y = y;
			
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
			mc.x = __controlx;
			mc.y = __controly;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}