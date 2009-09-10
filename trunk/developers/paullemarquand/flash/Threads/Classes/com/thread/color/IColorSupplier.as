package com.thread.color 
{

	/**
	 * @author Paul
	 */
	public interface IColorSupplier 
	{
		function get currentColor() : uint;
		function get framesPerColor() : uint;
		function set framesPerColor(n:uint) : void;
		function update() : void;
		function copy() : IColorSupplier;
	}
}
