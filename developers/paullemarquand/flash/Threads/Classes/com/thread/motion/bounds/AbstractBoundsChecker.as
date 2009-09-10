package com.thread.motion.bounds 
{
	import com.thread.motion.IMotionable;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;	

	/**
	 * @author Paul
	 */
	public class AbstractBoundsChecker implements IBoundsChecker 
	{
		protected var _target : IMotionable;

		public function AbstractBoundsChecker(enforcer : AbstractBoundsChecker) 
		{
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
