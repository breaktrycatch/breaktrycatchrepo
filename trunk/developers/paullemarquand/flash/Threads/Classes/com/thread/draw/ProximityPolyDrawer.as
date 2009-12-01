package com.thread.draw 
{	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.thread.vo.IPositionable;
	import com.util.NumberUtils;
	import com.util.Randomizer;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class ProximityPolyDrawer extends AbstractDrawer implements IDrawer 
	{
		private var _polySides : int;
		private var _polyRadius : int;
		public function ProximityPolyDrawer(maxSize : int = 30, polySides : int = 5)
		{
			_polyRadius = maxSize;
			_polySides = polySides;
						super( this );		}

		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			for (var i : Number = 0; i < lines.length ; i++) 
			{
				var nearest : int = NumberUtils.constrain( getNearest( lines[i].pt1 ), 1, _polyRadius );
				var polyDraw : PolyDrawer = new PolyDrawer( nearest, _polySides );
				polyDraw.draw( drawTarget, lines );			}
		}

		private function getNearest(pt : Point) : int
		{
			var nearest : int = int.MAX_VALUE;
			var threads : Array = _modifiers[0];
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

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "polyRadius", 3, 45 );
			randomizer.addRule( Number, "polySides", 3, 10 );
			randomizer.randomize( this );
		}
		
		public function get polySides() : int
		{
			return _polySides;
		}
		
		public function set polySides(polySides : int) : void
		{
			_polySides = polySides;
		}
		
		public function get polyRadius() : int
		{
			return _polyRadius;
		}
		
		public function set polyRadius(polyRadius : int) : void
		{
			_polyRadius = polyRadius;
		}
	}}