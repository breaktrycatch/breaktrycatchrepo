package com.fuelindustries.media 
{
	import flash.media.SoundChannel;

	/**
	 * @author jslater
	 */
	public class ObjectSound extends BaseSound 
	{
		private var __object : *;
		private var __channel:SoundChannel;
		public function ObjectSound(p_object : *)
		{
			__object = p_object;
		}
		protected function setTransform() : void
		{
			__object.soundTransform = __transform;
		}
		
		public function get object():*{
			
			return __object;
		}
		
		
		public override function volumeTo( volume:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			if( !__muted )
			{
				callbackArgs.unshift( callback );
				callbackArgs.unshift( type );
				callbackArgs.unshift( duration );
				callbackArgs.unshift( volume );
				callbackArgs.unshift( __object );
				__mm.volumeTo.apply( __mm, callbackArgs );
			}
			else
			{
				__lastMutedVolume = volume;
			}
		}
	}
}
