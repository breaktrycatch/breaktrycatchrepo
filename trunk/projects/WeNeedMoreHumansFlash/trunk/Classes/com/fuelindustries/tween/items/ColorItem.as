package com.fuelindustries.tween.items 
{
	import com.fuelindustries.tween.interfaces.ITransform;

	import flash.geom.ColorTransform;

	/** @private */
	public class ColorItem extends MotionItem implements IMotionItem
	{
		private var __destColorTransform : ColorTransform;
		private var __startValue : Number;
		private var __endValue : Number;
		private var __mc:ITransform;
		
		public function get mc():ITransform
		{
			return( __mc );	
		}
		
		public function ColorItem( mc : ITransform, color:uint, duration : int, ease : String, callback : Function, callbackArgs : Array )
		{
			super( duration, ease, callback, callbackArgs );
			__mc = mc;
			__destColorTransform = new ColorTransform( );

			__destColorTransform.color = color;
			__startValue = 0;
			__endValue = 1;
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;

			var value : Number = __easeFunction(timePassed / 1000, __startValue, __endValue - __startValue, __duration / 1000);
			__mc.transform.colorTransform = getColor(mc.transform.colorTransform, __destColorTransform, value);
			
			__currenttime = currentTime;
			
			if( __currenttime >= __endtime ) 
			{
				completed = true;
				tweenComplete();
			}
			
			return( completed );
		}

		private function getColor(start : ColorTransform, end : ColorTransform, t : Number) : ColorTransform 
		{
			var result : ColorTransform = new ColorTransform();
			result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier) * t;
			result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier) * t;
			result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier) * t;
			result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier) * t;
			result.redOffset = start.redOffset + (end.redOffset - start.redOffset) * t;
			result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset) * t;
			result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset) * t;
			result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * t;
			return result;
		}

		public override function tweenComplete() : void
		{
			var diffTime : int = __currenttime - __endtime;
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}