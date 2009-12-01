package com.thread.draw 
{	import com.thread.draw.IDrawer;
	import com.thread.vo.IRandomizable;
	import com.util.Randomizer;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class PolyDrawer extends AbstractDrawer implements IDrawer, IRandomizable
	{
		private var _polyRadius : Number;
		private var _polySides : int;
		private var _loopInc : Number;

		private static const TWOPI : Number = Math.PI * 2;

		public function PolyDrawer(polyRadius : Number = 10, polySides : int = 5) 
		{
			_polyRadius = polyRadius;
			_polySides = polySides;
			_loopInc = ( TWOPI ) / _polySides;
			
			super( this );
		}

		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			for (var j : Number = 0; j < lines.length ; j++) 
			{
				var midPt : Point = lines[j].interpolate( .5 );
				var sx : Number = midPt.x + Math.sin( 0 ) * _polyRadius;
				var sy : Number = midPt.y + Math.cos( 0 ) * _polyRadius;
				
				drawTarget.graphics.moveTo( sx, sy );
				
				for (var i : Number = _loopInc; i < TWOPI ; i += _loopInc) 
				{
					var x : Number = midPt.x + Math.sin( i ) * _polyRadius;
					var y : Number = midPt.y + Math.cos( i ) * _polyRadius;
					drawTarget.graphics.lineTo( x, y );
				}
				
				drawTarget.graphics.lineTo( sx, sy );
			}		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "polyRadius", 3, 45 );
			randomizer.addRule( Number, "polySides", 3, 10 );
			randomizer.randomize( this );
		}
		
		public function get polyRadius() : Number
		{
			return _polyRadius;
		}

		public function set polyRadius(polyRadius : Number) : void
		{
			_polyRadius = polyRadius;
		}

		public function get polySides() : int
		{
			return _polySides;
		}

		public function set polySides(polySides : int) : void
		{
			_polySides = polySides;
		}
	}}