package com.thread.transform 
{
	import com.thread.motion.IPositionable;
	import com.geom.Line;
	import com.thread.motion.IMotionable;

	import flash.display.Sprite;

	/**
	 * @author Paul
	 */
	public interface IDrawTransform 
	{
		function transform(d : IPositionable) : Vector.<Line>;
	}
}
