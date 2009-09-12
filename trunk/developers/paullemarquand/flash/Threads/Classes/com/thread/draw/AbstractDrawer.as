package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	/**	 * @author plemarquand	 */	public class AbstractDrawer implements IDrawer 
	{
		protected var _modifiers : Array;
		
		public function AbstractDrawer(enforcer : AbstractDrawer) 
		{
		}

		public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			throw new IllegalOperationError( "draw() not implemented in" + this );		}
		
		public function setModifiers(...args) : void
		{
			_modifiers = args;
		}
	}}