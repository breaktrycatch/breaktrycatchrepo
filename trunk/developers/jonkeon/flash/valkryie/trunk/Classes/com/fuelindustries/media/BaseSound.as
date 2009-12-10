package com.fuelindustries.media 
{
	import com.fuelindustries.tween.MotionManager;

	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author julian
	 */
	public class BaseSound extends EventDispatcher 
	{
		/** @private */
		protected var __mm:MotionManager;
		protected var __transform:SoundTransform;
		protected var __muted:Boolean;
		protected var __lastMutedVolume:Number;
				
		public function get isMuted():Boolean
		{
			return( __muted );	
		}
		
		public function BaseSound()
		{
			__mm = MotionManager.getInstance();
			__muted = false;			
		}
		
		
		public function volumeTo( volume:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			
		}
		
		public function play( startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ):SoundChannel
		{
			return null;
		}
		
		public function stop():void
		{
			
		}
		
		public function mute( val:Boolean, fade:Boolean = false, duration:int = 0 ):void
		{
			if( __muted != val )
			{
				if( val )
				{
					__lastMutedVolume = getVolume();
					if( fade )
					{
						volumeTo( 0, duration );	
					}
					else
					{
						setVolume( 0 );	
					}
					__muted = val;
					
					//trace( "muting sound last muted volume", __lastMutedVolume );
				}
				else
				{
					//trace( "unmuting sound last muted volume", __lastMutedVolume );
					__muted = val;
					if( fade )
					{
						
						volumeTo( __lastMutedVolume, duration );	
					}
					else
					{
						
						setVolume( __lastMutedVolume );	
					}
				}
				
			}
		}
						
		public function setVolume( vol:int ):void
		{
			volumeTo( vol, 0 );
		}
		
		public function getVolume():int
		{
			var transform:SoundTransform = getSoundTransform();
			if( transform != null )
			{
				var vol:Number = getSoundTransform().volume;
				return( vol * 100 );
			}
			
			return( 100 );
		}
		
		public function getSoundTransform():SoundTransform
		{
			return( __transform );
		}
		
		public function dispose():void
		{
			
		}

	}
}
