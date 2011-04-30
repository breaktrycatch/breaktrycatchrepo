package com.thread.bounds
{

	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import flash.geom.Point;

	/**
	 * @author Paul
	 */
	public class BounceBoundsChecker extends AbstractBoundsChecker implements IBoundsChecker
	{
		public function BounceBoundsChecker(target : IMotionable)
		{
			super( target, this );
		}

		override public function checkBounds(x : Number, y : Number) : Point
		{
			if ((x > ThreadConstants.MANAGER_WIDTH || x < 0) || (y > ThreadConstants.MANAGER_HEIGHT || y < 0))
			{
				_target.angle += 180;
				return resetPosition();
			}

			savePosition( x, y );
			return new Point( x, y );
		}
	}
}
