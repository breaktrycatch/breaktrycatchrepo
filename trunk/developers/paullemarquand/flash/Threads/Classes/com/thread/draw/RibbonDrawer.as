package com.thread.draw
{

	import com.geom.Line;
	import com.util.Randomizer;
	import flash.display.Sprite;

	/**
	 * @author plemarquand
	 */
	public class RibbonDrawer extends AbstractDrawer implements IDrawer
	{
		private var __currentPos : Array;
		private var __lastPos : Array;
		private var __drawers : Array;
		private var __ribbonWidth : Number;
		private var __ctr : Number;

		public function RibbonDrawer()
		{
			__drawers = [];
			__currentPos = [];
			__lastPos = [];
			__ribbonWidth = 1;
			__ctr = 0;
			
			super();
		}

		public function get ribbonWidth() : Number
		{
			return __ribbonWidth;
		}

		public function set ribbonWidth(_width : Number) : void
		{
			__ribbonWidth = _width;
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer();
			randomizer.addRule( Number, "ribbonWidth", 1, 1 );
			randomizer.randomize( this );
		}

		override public function draw(drawTarget : Sprite, lines : Array) : void
		{
			for (var i : int = 0; i < lines.length; i++)
			{
				var line : Line = lines[i];
				var drawer : SegmentDrawer = __drawers[i] || new SegmentDrawer();

				__drawers[i] = drawer;
				drawer.draw( drawTarget, line, ribbonWidth );
				
			}
		}
	}
}

import com.geom.Line;
import com.util.NumberUtils;
import flash.display.Sprite;
import flash.geom.Point;

class SegmentDrawer
{
	private var __lastP1 : Point;
	private var __lastP2 : Point;

	public function draw(_drawTarget : Sprite, _line : Line, _width : Number) : void
	{
		var rotRads : Number = -Math.atan2( _line.pt2.y - _line.pt1.y, _line.pt2.x - _line.pt1.x ) + Math.PI / 2;

		var baseX1 : Number = _line.pt1.x + Math.sin( rotRads - NumberUtils.PI_HALF ) * _width;
		var baseY1 : Number = _line.pt1.y + Math.cos( rotRads - NumberUtils.PI_HALF ) * _width;

		var baseX2 : Number = _line.pt1.x + Math.sin( rotRads + NumberUtils.PI_HALF ) * _width;
		var baseY2 : Number = _line.pt1.y + Math.cos( rotRads + NumberUtils.PI_HALF ) * _width;

		var endX1 : Number = _line.pt2.x + Math.sin( rotRads - NumberUtils.PI_HALF ) * _width;
		var endY1 : Number = _line.pt2.y + Math.cos( rotRads - NumberUtils.PI_HALF ) * _width;

		var endX2 : Number = _line.pt2.x + Math.sin( rotRads + NumberUtils.PI_HALF ) * _width;
		var endY2 : Number = _line.pt2.y + Math.cos( rotRads + NumberUtils.PI_HALF ) * _width;

		if (__lastP1)
		{
			_drawTarget.graphics.moveTo( __lastP1.x, __lastP1.y );
			_drawTarget.graphics.lineTo( __lastP2.x, __lastP2.y );
		}
		else
		{
			_drawTarget.graphics.moveTo( baseX1, baseY1 );
			_drawTarget.graphics.lineTo( baseX2, baseY2 );
		}

		_drawTarget.graphics.lineTo( endX2, endY2 );
		_drawTarget.graphics.lineTo( endX1, endY1 );

		__lastP1 ||= new Point();
		__lastP2 ||= new Point();

		__lastP1.x = endX1;
		__lastP2.x = endX2;

		__lastP1.y = endY1;
		__lastP2.y = endY2;
	}
}
