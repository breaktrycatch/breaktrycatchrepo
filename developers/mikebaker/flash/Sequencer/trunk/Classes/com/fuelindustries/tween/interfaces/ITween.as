package com.fuelindustries.tween.interfaces 
{

	/**
	 * @author julian
	 */
	public interface ITween extends ITweenable
	{
		function onTweenUpdate( ...args:Array ):void;
	}
}
