package com.thread.draw 
{	import com.thread.motion.IPositionable;
	import com.geom.Line;
	import com.thread.Thread;
	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.util.NumberUtils;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class ProximityPolyDrawer extends AbstractDrawer implements IDrawer 
	{
		private var _polySides : int;
		private var _maxSize : int;
		public function ProximityPolyDrawer(maxSize : int = 30, polySides : int = 5)
		{
			_maxSize = maxSize;
			_polySides = polySides;
						super( this );		}

		override public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			for (var i : Number = 0; i < lines.length ; i++) 
			{
				var nearest : int = NumberUtils.constrain( getNearest( lines[i].pt1 ), 1, _maxSize );
				var polyDraw : PolyDrawer = new PolyDrawer( nearest, _polySides );
				polyDraw.draw( drawTarget, lines );			}
		}

		private function getNearest(pt : Point) : int
		{
			var nearest : int = int.MAX_VALUE;
			var threads : Vector.<Thread> = _modifiers[0];
			for (var i : Number = 0; i < threads.length ; i++) 
			{
				var data : IPositionable = threads[i].data;
				var dist : Number = Point.distance( pt, new Point(data.x, data.y) );
				if(dist < nearest && dist != 0)
				{
					nearest = dist;
				}
			}
			return nearest;
		}
	}}