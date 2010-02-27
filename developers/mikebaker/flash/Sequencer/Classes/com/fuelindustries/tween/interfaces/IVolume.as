package com.fuelindustries.tween.interfaces 
{
	import flash.media.SoundTransform;

	/**
	 * @author julian
	 */
	public interface IVolume extends ITweenable
	{
		function get soundTransform():SoundTransform;
		function set soundTransform(sndTransform:SoundTransform):void;
		
	}
}
