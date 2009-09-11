package com.geom 
{	import com.thread.motion.IPositionable;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class Line implements IPositionable
	{
		private var _x1 : Number;
		private var _x2 : Number;
		private var _y1 : Number;
		private var _y2 : Number;
		private var _pt1 : Point;
		private var _pt2 : Point;

		public function Line(x1 : Number, y1 : Number, x2 : Number, y2 : Number) 
		{
			_x1 = x1;
			_x2 = x2;
			_y1 = y1;
			_y2 = y2;
			
			_pt1 = new Point( x1, y1 );
			_pt2 = new Point( x2, y2 );
		}

		public function get pt1() : Point
		{
			return _pt1;
		}

		public function get pt2() : Point
		{
			return _pt2;
		}
		
		public function get length() : Number
		{
			return Point.distance(pt1, pt2);
		}
		
		public function interpolate(t:Number):Point
		{
			return Point.interpolate(pt1, pt2, t);
		}
		
		public static function createFromPoints(pt1 : Point, pt2 : Point) : Line
		{
			return new Line(pt1.x, pt1.y, pt2.x, pt2.y );
		}
		
		public function get x() : Number
		{
			return _x2;
		}
		
		public function get y() : Number
		{
			return _y2;
		}
		
		public function get prevX() : Number
		{
			return _x1;
		}
		
		public function get prevY() : Number
		{
			return _y2;
		}
		
		public function set x(n : Number) : void
		{
			_x2 = n;
		}
		
		public function set y(n : Number) : void
		{
			_y2 = n;
		}
		
		public function set prevX(n : Number) : void
		{
			_x1 = n;
		}
		
		public function set prevY(n : Number) : void
		{
			_y1 = n;
		}	}}