package com.fuelindustries.media.sound 
{
	import com.fuelindustries.tween.interfaces.IVolume;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * @author sjohn
	 */
	public class MP3Sound extends BaseSound implements IVolume
	{
		private var __audioURL:String;
		private var __sound:Sound;
		private var __channel:SoundChannel;


		public function MP3Sound( audioURL:String )
		{
			super( );

			__sound = new Sound( );
			__audioURL = audioURL;
		}


		public override function play( startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ):SoundChannel
		{

			super.play( startTime, loops, sndTransform );
			
			__sound.load( new URLRequest( __audioURL ) );
			__channel = __sound.play( startTime, loops, __transform );
		
			return __channel;
		}

		public override function stop():void
		{
			if( __channel != null )
			{
				__transform = __channel.soundTransform;
			
				
				try 
				{
					__channel.stop( );
					__sound.close( );
					__sound = null;
				}
				catch (e:Error) 
				{
				//Nothing to close;
				}
			}	
		}

		public override function volumeTo( volume:int, duration:int, type:String = null, callback:Function = null, ...callbackArgs:Array ):void
		{
			if( __channel != null )
			{
				callbackArgs.unshift( callback );
				callbackArgs.unshift( type );
				callbackArgs.unshift( duration );
				callbackArgs.unshift( volume );
				super.volumeTo.apply( super, callbackArgs );
			}	
		}
		
		override public function set soundTransform( sndTransform:SoundTransform ):void
		{
			__transform = sndTransform;
			if( __channel != null )
			{
				__channel.soundTransform = __transform;	
			}
		}

		override public function get soundTransform():SoundTransform
		{
			if( __channel != null )
			{
				return( __channel.soundTransform );	
			}
			
			return( __transform );
		}
	}
}