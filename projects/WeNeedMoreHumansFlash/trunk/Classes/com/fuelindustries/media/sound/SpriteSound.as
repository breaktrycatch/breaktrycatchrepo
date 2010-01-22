package com.fuelindustries.media.sound 
{
	import flash.errors.IllegalOperationError;
	import flash.media.SoundChannel;

	import com.fuelindustries.tween.interfaces.IVolume;

	import flash.display.Sprite;
	import flash.media.SoundTransform;

	/**
	 * @author julian
	 */
	public class SpriteSound extends BaseSound implements IVolume
	{
		private var __sprite:Sprite;
		
		public function SpriteSound( target:Sprite )
		{
			super();
			__sprite = target;
			__transform = target.soundTransform;
		}
		
		override public function set soundTransform( sndTransform:SoundTransform ):void
		{
			__transform = sndTransform;
			if( __sprite != null )
			{
				__sprite.soundTransform = __transform;	
			}
		}

		override public function get soundTransform():SoundTransform
		{
			if( __sprite != null )
			{
				return( __sprite.soundTransform );	
			}
			
			return( __transform );
		}

		override public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel
		{
			throw new IllegalOperationError( "Can't play a SpriteSound Object" );
			return super.play( startTime, loops, sndTransform );
		}

		override public function stop():void
		{
			throw new IllegalOperationError( "Can't stop a SpriteSound Object" );
		}
	}
}
