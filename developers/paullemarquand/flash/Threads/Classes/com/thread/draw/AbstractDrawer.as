package com.thread.draw 
{
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;	

	/**
	 * @author Paul
	 */
	public class AbstractDrawer implements IDrawer 
	{
		public function AbstractDrawer(enforcer : AbstractDrawer) 
		{
			
		}
		
		public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			throw new IllegalOperationError( "draw() not implemented in" + this );
		}
	}
}
