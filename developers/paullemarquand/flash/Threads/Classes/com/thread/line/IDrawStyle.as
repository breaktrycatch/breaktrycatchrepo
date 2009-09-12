package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.motion.ILineStyleable;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public interface IDrawStyle 
	{
		function set colorSupplier(color : IColorSupplier) : void;

		function set target(d : ILineStyleable) : void;

		function preDraw(drawTarget : Sprite) : void;

		function postDraw(drawTarget : Sprite) : void;
		
		function setModifiers(...args) : void;
		
	}
}
