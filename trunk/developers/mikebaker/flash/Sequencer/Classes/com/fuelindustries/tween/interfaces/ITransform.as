package com.fuelindustries.tween.interfaces 
{
	import flash.geom.Transform;

	/**
	 * @author julian
	 */
	public interface ITransform extends ITweenable
	{
		function get transform():Transform;

		function set transform(value:Transform):void;
	}
}
