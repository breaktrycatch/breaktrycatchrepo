package com.thread.draw 
{	import com.thread.draw.IDrawer;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class SimpleDrawer extends AbstractDrawer implements IDrawer 
	{
		public function SimpleDrawer() 
		{
			super( this );
		}
		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			var len : int = lines.length;
			for (var i : Number = 0; i < len ; i++) 
			{
				drawTarget.graphics.moveTo( lines[i].pt1.x, lines[i].pt1.y );
				drawTarget.graphics.lineTo( lines[i].pt2.x, lines[i].pt2.y );
			}
		}

		override public function randomize() : void
		{
			// do nothing
		}
	}}