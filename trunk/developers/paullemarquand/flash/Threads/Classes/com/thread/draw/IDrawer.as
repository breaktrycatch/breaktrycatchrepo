package com.thread.draw 
{	import com.geom.Line;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public interface IDrawer 
	{
		function draw(drawTarget : Sprite, lines : Vector.<Line>) : void;

		function setModifiers(...args) : void;	}}