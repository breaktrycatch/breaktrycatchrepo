package com.thread.motion.bounds 
{
	import com.thread.motion.IMotionable;
	
	import flash.geom.Point;		

	/**
	 * @author Paul
	 */
	public interface IBoundsChecker 
	{
		function set target(v : IMotionable) : void;

		function checkBounds(x:Number, y:Number) : Point;
	}
}
