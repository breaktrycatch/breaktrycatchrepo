package com.fuelindustries.tween.interfaces 
{

	/**
	 * @author julian
	 */
	public interface IFilter extends ITweenable
	{
		function get filters():Array;
		function set filters(value:Array):void;
	}
}
