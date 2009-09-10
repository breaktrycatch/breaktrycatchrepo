package com.thread.motion.bounds 
{
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.bounds.AbstractBoundsChecker;
	import com.thread.motion.bounds.IBoundsChecker;
	
	import flash.geom.Point;	

	/**
	 * @author Paul
	 */
	public class ContinuationBoundsChecker extends AbstractBoundsChecker implements IBoundsChecker 
	{
		public function ContinuationBoundsChecker()
		{
			super(this);
		}

		override public function checkBounds(x : Number, y : Number) : Point
		{
			var nP : Point = new Point(x, y);
			if(x > ThreadConstants.MANAGER_WIDTH ) 
			{
				nP.x = 0;
				_target.x = 0;
				//_target.x = 0;
			}
			else if (x < 0) 
			{
				nP.x = ThreadConstants.MANAGER_WIDTH;
				_target.x = ThreadConstants.MANAGER_WIDTH;
				//_target.x = ThreadConstants.MANAGER_WIDTH;
			}
				
			if(y > ThreadConstants.MANAGER_HEIGHT) 
			{
				nP.y = 0;
				_target.y = 0;
				//_target.y = 0;
			}
			else if ( y < 0) 
			{
				nP.y = ThreadConstants.MANAGER_HEIGHT;
				_target.y = ThreadConstants.MANAGER_HEIGHT;
				//_target.y = ThreadConstants.MANAGER_HEIGHT;
			}
			
			return nP;
		}
	}
}
