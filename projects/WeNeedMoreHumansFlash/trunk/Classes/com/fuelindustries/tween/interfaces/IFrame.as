package com.fuelindustries.tween.interfaces 
{

	/**
	 * @author julian
	 */
	public interface IFrame extends ITweenable
	{
		function gotoAndStop(frame:Object, scene:String = null):void;
		function get currentFrame():int;
		function get currentLabel():String;
		function get currentLabels():Array;
		function get totalFrames():int;
	}
}
