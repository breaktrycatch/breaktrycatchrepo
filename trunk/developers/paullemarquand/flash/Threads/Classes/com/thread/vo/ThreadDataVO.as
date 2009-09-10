package com.thread.vo 
{
	import com.thread.motion.ILineStyleable;
	import com.thread.motion.IMotionable;		

	/**
	 * @author Paul
	 */
	public class ThreadDataVO implements IMotionable, ILineStyleable
	{
		private var _x : Number;
		private var _y : Number;

		private var _prevX : Number;
		private var _prevY : Number;

		private var _angle : Number;
		private var _speed : Number;

		private var _lineSize : Number;
		private var _lineAlpha : Number;
		private var _initialSpeed : Number;

		public function ThreadDataVO() 
		{
			prevX = 0;
			prevY = 0;
			_x = 0;
			_y = 0;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set x(n : Number) : void
		{
			prevX = _x;
			_x = n;
		}

		public function set y(n : Number) : void
		{
			prevY = _y;
			_y = n;
		}

		public function get prevX() : Number
		{
			return _prevX;
		}

		public function get prevY() : Number
		{
			return _prevY;
		}

		public function set prevX(n : Number) : void
		{
			_prevX = n;
		}

		public function set prevY(n : Number) : void
		{
			_prevY = n;
		}

		public function get angle() : Number
		{
			return _angle;
		}

		public function set angle(n : Number) : void
		{
			_angle = n;
		}

		public function get speed() : Number
		{
			return _speed;
		}

		public function set speed(n : Number) : void
		{
			_speed = n;
		}

		public function get lineSize() : Number
		{
			return _lineSize;
		}

		public function set lineSize(n : Number) : void
		{
			_lineSize = n;
		}

		public function get lineAlpha() : Number
		{
			return _lineAlpha;
		}

		public function set lineAlpha(n : Number) : void
		{
			_lineAlpha = n;
		}

		public function get initialSpeed() : Number
		{
			return _initialSpeed;
		}

		public function set initialSpeed(n : Number) : void
		{
			_initialSpeed = n;
			speed = n;
		}
	}
}
