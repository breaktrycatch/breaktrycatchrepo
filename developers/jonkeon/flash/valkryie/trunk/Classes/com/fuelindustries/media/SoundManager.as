package com.fuelindustries.media 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.utils.Dictionary;

	/**
	 * @author jdolce
	 */
	public class SoundManager extends EventDispatcher
	{
		public static const MUTE:String = "mute";
		private static var __instance:SoundManager;
		private static var allowInstantiation:Boolean = false;
		private var __muted:Boolean;
		private var __soundList:Dictionary;

		public static function getInstance():SoundManager
		{
			if (__instance == null)
			{
				allowInstantiation = true;
				__instance = new SoundManager( );	
				allowInstantiation = false;
			}
			
			return (__instance);
		}

		public function get isMuted():Boolean
		{
			return (__muted);
		}

		public function SoundManager()
		{
			if( !allowInstantiation )
			{
				//throw new Error( "SoundManagerManager.allowInstantiation == false" );
			}
			else
			{
				init( );	
			}
		}

		private function init():void
		{	
			__muted = false;
			__soundList = new Dictionary( true );	
		}

		private function registerSound( id:String, sound:BaseSound ):void
		{
			sound.mute( __muted, false );
			__soundList[ id ] = sound;
		}

		private function remove( id:String ):void
		{
			var sound:BaseSound = __soundList[ id ] as BaseSound;
			sound.dispose( );
			
			delete(__soundList[ id ] );	
		}

		public function addSound( id:String, target:DisplayObject = null ):void
		{
			var sound:FuelSound = new FuelSound( id, target );
			registerSound( id, sound );
		}

		public function removeSound( id:String ):void
		{
			remove( id );
		}

		public function addSprite( id:String, sprite:Sprite ):void
		{
			var sound:SpriteSound = new SpriteSound( sprite );
			registerSound( id, sound );
		}

		public function addStream( id:String, stream:NetStream ):void
		{
			var sound:ObjectSound = new ObjectSound( stream );
			stream.soundTransform = new SoundTransform( isMuted ? 0 : 1 );
			registerSound( id, sound );
		}

		public function addMP3Stream( id:String, target:DisplayObject = null ):void
		{
			var sound:MP3Sound = new MP3Sound( id, target );
			registerSound( id, sound );
		}

		public function removeSprite( id:String ):void
		{
			remove( id );	
		}

		public function playSound( id:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ):SoundChannel
		{
			//trace( "sm playSound", id );
			var sound:BaseSound = getSound( id );
			
			
			if( sound is FuelSound )
			{
				return sound.play( startTime, loops, sndTransform );
			}
			else if (sound is ObjectSound)
			{
				trace( "playSound is ObjectSound" );
				
				if (ObjectSound( sound ).object is NetStream)
				{
					trace( "playSound is netstream" );
					return ObjectSound( sound ).object.play( id );
				}
			}else if (sound is MP3Sound)
			{
				trace( "playSound is MP3Sound" );
				return MP3Sound( sound ).play(startTime, loops, sndTransform );
			}
			else
			{
				throw new Error( id + " is not a sound that can be played" );	
			}
			return null;
		}

		public function stopSound( id:String ):void
		{
			var sound:BaseSound = getSound( id );
			if( sound is FuelSound )
			{
				sound.stop( );
			}else if (sound is MP3Sound)
			{
				trace( "stopSound is MP3Sound" );
				MP3Sound( sound ).stop();
			}
			else
			{
				throw new Error( id + " is not a sound that can be stopped" );	
			}
		}

		public function setVolume( id:String, vol:int ):void
		{
			var sound:BaseSound = getSound( id );
			sound.setVolume( vol );
		}

		public function volumeTo( id:String, volume:int, duration:int, type:*= null, callback:Function = null, ...callbackArgs:Array):void
		{
			var sound:BaseSound = getSound( id );
			callbackArgs.unshift( callback );
			callbackArgs.unshift( type );
			callbackArgs.unshift( duration );
			callbackArgs.unshift( volume );
			sound.volumeTo.apply( sound, callbackArgs ); 
		}

		public function mute( val:Boolean, fade:Boolean = false, duration:int = 0 ):void
		{
			
			//trace( "muting = ", val );
			if( __muted != val )
			{
				__muted = val;
				for each( var sound:BaseSound in __soundList )
				{
					sound.mute( val, fade, duration );	
				}
				
				dispatchEvent( new Event( SoundManager.MUTE ) );
			}
		}

		private function getSound( id:String ):BaseSound
		{
			return( __soundList[ id ] as BaseSound );
		}
	}
}