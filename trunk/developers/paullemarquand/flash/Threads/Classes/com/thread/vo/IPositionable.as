package com.thread.vo 
{

	/**
	 * @author Paul
	 */
	public interface IPositionable 
	{
		function get x() : Number;

		function get y() : Number;

		function set x(n : Number) : void;

		function set y(n : Number) : void;

		function get prevX() : Number;

		function get prevY() : Number;

		function set prevX(n : Number) : void;

		function set prevY(n : Number) : void;
	}
}
