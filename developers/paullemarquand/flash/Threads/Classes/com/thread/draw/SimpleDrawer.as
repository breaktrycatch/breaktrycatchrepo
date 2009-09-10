package com.thread.draw 
{
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class SimpleDrawer extends AbstractDrawer implements IDrawer 
	{
		public function SimpleDrawer() 
		{
			super(this);
		}
		
		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			drawTarget.graphics.moveTo( d.prevX, d.prevY );
			drawTarget.graphics.lineTo( d.x, d.y ) ;
		}
	}
}
