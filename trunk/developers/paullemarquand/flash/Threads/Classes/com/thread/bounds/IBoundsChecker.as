package com.thread.bounds 
{
	import com.thread.vo.IMotionable;

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
