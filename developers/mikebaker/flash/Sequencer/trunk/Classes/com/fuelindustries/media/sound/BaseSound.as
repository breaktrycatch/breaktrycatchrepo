package com.fuelindustries.media.sound 
{
	import com.fuelindustries.tween.interfaces.IVolume;
	import com.fuelindustries.tween.MotionManager;

	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author julian
	 */
	public class BaseSound extends EventDispatcher implements IVolume
	{
		/** @private */
		
		protected var __transform:SoundTransform;
		protected var __muted:Boolean;
		protected var __lastMutedVolume:Number;
		protected var __mm:MotionManager;
				
		public function get isMuted():Boolean
		{
			return( __muted );	
		}
		
		public function BaseSound()
		{
			__muted = false;
			__mm = MotionManager.getInstance();			
		}
		
		
		public function volumeTo( volume:int, duration:int, type:String = null, callback:Function = null, ...callbackArgs:Array ):void
		{
			if( !__muted )
			{
				callbackArgs.unshift( callback );
				callbackArgs.unshift( type );
				callbackArgs.unshift( duration );
				callbackArgs.unshift( volume );
				callbackArgs.unshift( this );
				__mm.volumeTo.apply( __mm, callbackArgs );
					
				if( __transform != null )
				{
					__transform.volume = volume / 100;
				}
			}
			else
			{
				__lastMutedVolume = volume;
			}
		}

		public function play( startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null ):SoundChannel
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

				}
				else
				{
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
			if( this.soundTransform != null )
			{
				var vol:Number = this.soundTransform.volume;
				return( vol * 100 );
			}
			
			return( 100 );
		}
						
		public function dispose():void
		{
		}
		
		public function get soundTransform():SoundTransform
		{
			return __transform;
		}
		
		public function set soundTransform(sndTransform:SoundTransform):void
		{
			__transform = sndTransform;
		}
	}
}
