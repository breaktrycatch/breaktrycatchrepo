package com.thread.ai 
{
	import com.thread.vo.IMotionable;
	import com.thread.vo.IUpdateable;

	/**
	 * @author Paul
	 */
	public interface IAgent extends IUpdateable
	{
		function set target(t : IMotionable) : void;

		function setModifiers(...args) : void;

		function randomize() : void;
		
		function run() : void;
	}
}
