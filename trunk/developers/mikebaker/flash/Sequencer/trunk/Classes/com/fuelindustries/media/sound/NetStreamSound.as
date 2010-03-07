package com.fuelindustries.media.sound 
{
	import com.fuelindustries.tween.interfaces.IVolume;

	import flash.errors.IllegalOperationError;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetStream;

	/**
	 * @author julian
	 */
	public class NetStreamSound extends BaseSound implements IVolume
	{
		
		private var __stream:NetStream;
		
		public function NetStreamSound( stream:NetStream )
		{
			__stream = stream;
			__transform = stream.soundTransform;
		}
		
		override public function set soundTransform( sndTransform:SoundTransform ):void
		{
			__transform = sndTransform;
			if( __stream != null )
			{
				__stream.soundTransform = __transform;	
			}
		}

		override public function get soundTransform():SoundTransform
		{
			if( __stream != null )
			{
				return( __stream.soundTransform );	
			}
			
			return( __transform );
		}
		
		override public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel
		{
			throw new IllegalOperationError( "Can't play a NetStreamSound Object" );
			return super.play( startTime, loops, sndTransform );
		}

		override public function stop():void
		{
			throw new IllegalOperationError( "Can't stop a NetStreamSound Object" );
		}
	}
}
