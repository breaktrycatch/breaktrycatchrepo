package com.thread.bounds
{

	import com.thread.vo.IMotionable;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class AbstractBoundsChecker implements IBoundsChecker
	{
		protected var _target : IMotionable;
		private var __savedPoint : Point;

		public function AbstractBoundsChecker(target : IMotionable, enforcer : AbstractBoundsChecker)
		{
			enforcer = null;
			_target = target;
			__savedPoint = new Point();
		}

		protected function savePosition(_x : Number, _y : Number) : void
		{
			__savedPoint.x = _x;
			__savedPoint.y = _y;
		}

		protected function resetPosition() : Point
		{
			return __savedPoint;
		}

		public function checkBounds(x : Number, y : Number) : Point
		{
			throw new IllegalOperationError( "checkBounds() not implemented in" + this );
		}

		public function set target(v : IMotionable) : void
		{
			_target = v;
		}
	}
}
