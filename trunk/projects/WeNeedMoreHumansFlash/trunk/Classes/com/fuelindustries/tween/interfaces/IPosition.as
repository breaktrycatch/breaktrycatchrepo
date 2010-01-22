package com.fuelindustries.tween.interfaces 
{

	/**
	 * @author julian
	 */
	public interface IPosition extends ITweenable
	{
		function set x( _x:Number ):void
		function get x():Number;
		
		function set y( _y:Number ):void
		function get y():Number;
	}
}
