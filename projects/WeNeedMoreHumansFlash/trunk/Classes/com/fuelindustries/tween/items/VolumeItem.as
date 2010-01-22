package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IVolume;

	import flash.media.*;

	/** @private */
	public class VolumeItem extends MotionItem implements IMotionItem
	{
		private var __destVolume:int;
		private var __startVolume:Number;

		private var __mc:IVolume;
		
		public function get mc():IVolume
		{
			return( __mc );	
		}

		public function VolumeItem( mc:IVolume, volume:int, duration:int, ease:String, callback:Function, callbackArgs:Array )
		{
			super( duration, ease, callback, callbackArgs );
			__destVolume = volume;
			__mc = mc;
			if( __mc.soundTransform != null )
			{
				__startVolume = __mc.soundTransform.volume * 100;
			}
			else
			{
				__startVolume = 1;	
			}
					
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;

			var newvolume:Number = __easeFunction( timePassed/1000, __startVolume, __destVolume - __startVolume, __duration/1000 );
			
			var sndTransform:SoundTransform = new SoundTransform( newvolume / 100 );
			__mc.soundTransform = sndTransform;
			
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
			var sndTransform:SoundTransform = new SoundTransform( __destVolume / 100 );
			__mc.soundTransform = sndTransform;
			__timeDiff = diffTime;
		}
	}
}