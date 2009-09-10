package com.thread.draw 
{
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;		

	/**
	 * @author Paul
	 */
	public interface IDrawer 
	{
		function draw(drawTarget : Sprite, d : IMotionable) : void;
	}
}
