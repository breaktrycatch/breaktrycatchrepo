package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class SquareDrawer extends AbstractDrawer implements IDrawer 
	{
		public function SquareDrawer() 
		{
			super( this );
		}

		override public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			var len : int = lines.length;
			for (var i : Number = 0; i < len ; i++) 
			{
				var radius : Number = lines[i].length;	
				drawTarget.graphics.drawRect( lines[i].pt1.x, lines[i].pt1.y, radius, radius );
			}
		}
	}}