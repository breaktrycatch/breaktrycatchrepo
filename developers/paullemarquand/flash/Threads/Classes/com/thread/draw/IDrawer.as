package com.thread.draw 
{	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public interface IDrawer 
	{
		function draw(drawTarget : Sprite, lines : Array) : void;

		function setModifiers(...args) : void;	}}