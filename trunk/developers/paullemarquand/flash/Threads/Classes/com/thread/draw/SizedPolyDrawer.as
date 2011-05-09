package com.thread.draw 
{	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.util.Randomizer;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class SizedPolyDrawer extends AbstractDrawer implements IDrawer 
	{
		private var _polyRadius : Number;
		private var _polySides : int;
		public function SizedPolyDrawer(polyRadius : Number = 10, polySides : int = 5)
		{
			_polyRadius = polyRadius;
			_polySides = polySides;
						super();		}

		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			var size : Number = (_modifiers[1] / _modifiers[0].length) * _polyRadius;
			var drawer : PolyDrawer = new PolyDrawer( size, _polySides );
			drawer.draw( drawTarget, lines );		}
		
		

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