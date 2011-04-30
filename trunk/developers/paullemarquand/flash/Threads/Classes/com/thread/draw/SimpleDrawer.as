package com.thread.draw
{

	import com.geom.Line;
	import com.thread.draw.IDrawer;
	import flash.display.Sprite;

	/**	 * @author plemarquand	 */
	public class SimpleDrawer extends AbstractDrawer implements IDrawer
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
				var line : Line = lines[i];
				drawTarget.graphics.moveTo( line.pt1.x, line.pt1.y );
				drawTarget.graphics.lineTo( line.pt2.x, line.pt2.y );
			}
		}

		override public function randomize() : void
		{
			// do nothing
		}
	}
}