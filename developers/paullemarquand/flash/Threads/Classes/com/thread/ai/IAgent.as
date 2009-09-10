package com.thread.ai 
{
	import com.thread.motion.IUpdateable;	
	import com.thread.motion.IMotionable;	

	/**
	 * @author Paul
	 */
	public interface IAgent extends IUpdateable
	{
		function set target(t : IMotionable) : void;

		function setModifiers(...args) : void;

		function randomize() : void;
	}
}
