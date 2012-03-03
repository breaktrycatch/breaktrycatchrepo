package com.thread.vo
{

	import com.thread.constant.ThreadConstants;
	import com.util.Randomizer;

	/**
	 * @author Paul
	 */
	public class ThreadDataVO implements IMotionable, ILineStyleable, IRandomizable
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
		private var _followSpeedRange : Number;

		public function ThreadDataVO()
		{
			prevX = 0;
			prevY = 0;
			_x = 0;
			_y = 0;
			_angle = 0;
			_speed = 1;
			_lineSize = 1;
			_lineAlpha = 1;
			_initialSpeed = 1;
			_followSpeedRange = 0;

			randomize();
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

		public function get followSpeedRange() : Number
		{
			return _followSpeedRange;
		}

		public function set followSpeedRange(n : Number) : void
		{
			_followSpeedRange = n;
		}

		public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer();
			randomizer.addRule( Number, "angle", 267, 273 );
			randomizer.addRule( Number, "x", 0, ThreadConstants.MANAGER_WIDTH );
			randomizer.addRule( Number, "y", 0, ThreadConstants.MANAGER_HEIGHT );

			// initial speed should have no variance.
			randomizer.addRule( Number, "initialSpeed", 3.6, 3.6 );
			randomizer.addRule( Number, "lineSize", .1, 1 );
			randomizer.addRule( Number, "lineAlpha", .1, .1 );
			randomizer.addRule( Number, "followSpeedRange", .8, .8 );
			randomizer.addRule( Number, 'x', 0, ThreadConstants.MANAGER_WIDTH - ThreadConstants.MARGIN_X * 2 );
			randomizer.addRule( Number, 'y', 0, ThreadConstants.MANAGER_HEIGHT - ThreadConstants.MARGIN_Y * 2 );
			randomizer.randomize( this );

			x = ThreadConstants.MANAGER_WIDTH / 2 - Math.random() * 20 + Math.random() * 20;
			y = ThreadConstants.MANAGER_HEIGHT / 2 - Math.abs( ThreadConstants.MARGIN_Y );
			angle = Math.random() * 360;
			angle -= angle % 90;
			// / 2;
			
			// 2;
		}
	}
}
