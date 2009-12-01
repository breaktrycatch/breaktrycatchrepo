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

		public function AbstractBoundsChecker(target : IMotionable, enforcer : AbstractBoundsChecker) 
		{
			enforcer = null;
			_target = target;
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
