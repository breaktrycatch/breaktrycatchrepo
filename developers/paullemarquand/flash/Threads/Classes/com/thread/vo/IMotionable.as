package com.thread.vo 
{

	/**
	 * @author Paul
	 */
	public interface IMotionable extends IPositionable, IAngleable
	{
		function get speed() : Number;

		function set speed(n : Number) : void

		function get initialSpeed() : Number;

		function set initialSpeed(n : Number) : void;
	}
}
