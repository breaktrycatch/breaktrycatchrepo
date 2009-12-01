package com.thread.draw 
{	import com.thread.draw.IDrawer;
	import com.thread.vo.IRandomizable;

	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	/**	 * @author plemarquand	 */	public class AbstractDrawer implements IDrawer, IRandomizable 
	{
		protected var _modifiers : Array;

		public function AbstractDrawer(enforcer : AbstractDrawer) 
		{
		}

		public function draw(drawTarget : Sprite, lines : Array) : void
		{
			throw new IllegalOperationError( "draw() not implemented in" + this );		}

		public function randomize() : void
		{
			throw new IllegalOperationError( "randomize() not implemented in" + this );
		}
		
		public function setModifiers(...args) : void
		{
			_modifiers = args;
		}
	}}