package com.fuelindustries.tween.items
{
	/** @private */
	internal interface IMotionItem
	{
		function update( motiontime:int ):Boolean
		function tweenComplete():void
	}
}