package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class SizedPolyDrawer extends AbstractDrawer implements IDrawer 
	{
		private var _maxSize : Number;
		private var _polySides : int;
		public function SizedPolyDrawer(maxSize : Number = 10, polySides : int = 5)
		{
			_maxSize = maxSize;
			_polySides = polySides;
						super( this );		}

		override public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			var size : Number = (_modifiers[1] / _modifiers[0].length) * _maxSize;
			var drawer : PolyDrawer = new PolyDrawer( size, _polySides );
			drawer.draw( drawTarget, lines );		}
	}}