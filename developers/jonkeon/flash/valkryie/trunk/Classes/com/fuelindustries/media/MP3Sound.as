package com.fuelindustries.media 
{
	import flash.display.DisplayObject;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	/**
	 * @author sjohn
	 */
	public class MP3Sound extends BaseSound 
	{
		private var __audioURL:String;
		private var __sound:Sound;
		private var __channel:SoundChannel;
		private var __applicationDomain:ApplicationDomain;

		public function MP3Sound( audioURL:String, target:DisplayObject = null )
		{
			super( );
			
			setApplicationDomain( target );
			
			__sound = new Sound( );
						
			__audioURL = audioURL;
		}

		public function setApplicationDomain( target:DisplayObject ):void
		{
			if( target != null )
			{
				__applicationDomain = target.loaderInfo.applicationDomain;
			}
		}

		public override function play( startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ):SoundChannel
		{

			if( sndTransform != null )
			{
				__transform = sndTransform;
			}
			
			if( __muted )
			{
				if( __transform == null )
				{
					__transform = new SoundTransform( );	
				}

				__transform.volume = 0;	
			}
			
			if(  __transform != null )
			{
				//trace( __lastMutedVolume, __transform.volume );
			}
			
			if( __channel != null )
			{
				//trace( "play sound transform", __channel.soundTransform );
			}
			
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

		public override function volumeTo( volume:int, duration:int, type:*= null, callback:Function = null, ...callbackArgs:Array ):void
		{
			if( __channel != null )
			{
				if( !__muted )
				{
					//trace( "changing volume to ", volume );
					callbackArgs.unshift( callback );
					callbackArgs.unshift( type );
					callbackArgs.unshift( duration );
					callbackArgs.unshift( volume );
					callbackArgs.unshift( __channel );
					__mm.volumeTo.apply( __mm, callbackArgs );
					
					if( __channel != null && __transform != null )
					{
						__transform.volume = volume / 100;
					}
				}
				else
				{
					__lastMutedVolume = volume;
				}
			}
			else
			{
				//trace( "Can't set volume before sound has started playing" );
			} 	
		}

		public override function getSoundTransform():SoundTransform
		{
			if( __channel != null )
			{
				return( __channel.soundTransform );	
			}
			else
			{
				return( __transform );	
			}
		}
	}
}