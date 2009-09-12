package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class PolyDrawer implements IDrawer 
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
		}

		public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			for (var j : Number = 0; j < lines.length ; j++) 
			{
				var midPt : Point = lines[j].interpolate( .5 );
				var sx : Number = midPt.x + Math.sin( 0 ) * _polyRadius;
				var sy : Number = midPt.y + Math.cos( 0 ) * _polyRadius;
				
				drawTarget.graphics.moveTo( sx, sy );
				
				for (var i : Number = _loopInc; i < TWOPI; i += _loopInc) 
				{
					var x : Number = midPt.x + Math.sin( i ) * _polyRadius;
					var y : Number = midPt.y + Math.cos( i ) * _polyRadius;
					drawTarget.graphics.lineTo( x, y );
				}
				var ex : Number = midPt.x + Math.sin( TWOPI ) * _polyRadius;
				var ey : Number = midPt.y + Math.cos( TWOPI ) * _polyRadius;
				
				drawTarget.graphics.lineTo( sx, sy );
				
				
			}		}
	}}