package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.motion.IPositionable;
	/**
	 * @author Paul
	 */
	public interface IDrawTransform 
	{
		function transform(d : IPositionable) : Vector.<Line>;
	}
}
