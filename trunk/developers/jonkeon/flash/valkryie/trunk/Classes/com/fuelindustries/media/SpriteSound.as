package com.fuelindustries.media 
{
	import flash.display.Sprite;
	import flash.media.SoundTransform;

	/**
	 * @author julian
	 */
	public class SpriteSound extends BaseSound 
	{
		private var __sprite:Sprite;
		
		public function SpriteSound( target:Sprite )
		{
			super();
			__sprite = target;
			__transform = target.soundTransform;
		}
		
		public override function volumeTo( volume:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			if( !__muted )
			{
				callbackArgs.unshift( callback );
				callbackArgs.unshift( type );
				callbackArgs.unshift( duration );
				callbackArgs.unshift( volume );
				callbackArgs.unshift( __sprite );
				__mm.volumeTo.apply( __mm, callbackArgs ); 
			}
			else
			{
				__lastMutedVolume = volume;
			}
		}
		
		
		public override function getSoundTransform():SoundTransform
		{
			return( __sprite.soundTransform );
		}
	}
}
