package com.thread.transform 
{
	import com.thread.vo.IPositionable;
	/**
	 * @author Paul
	 */
	public interface IDrawTransform 
	{
		function transform(d : IPositionable) : Array;
	}
}
