package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class SimpleDrawer implements IDrawer 
	{		public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			var len : int = lines.length;
			for (var i : Number = 0; i < len; i++) 
			{
				drawTarget.graphics.moveTo(lines[i].pt1.x, lines[i].pt1.y);
				drawTarget.graphics.lineTo(lines[i].pt2.x, lines[i].pt2.y);
			}
		}
	}}