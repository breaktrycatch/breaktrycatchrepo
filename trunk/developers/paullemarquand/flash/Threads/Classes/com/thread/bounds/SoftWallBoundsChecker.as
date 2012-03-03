package com.thread.bounds
{

	import com.util.NumberUtils;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author plemarquand
	 */
	public class SoftWallBoundsChecker extends AbstractBoundsChecker implements IBoundsChecker
	{
		private var __wallRatio : Number;
		private var __innerRect : Rectangle;
		private var __canvasRect : Rectangle;
		private var __targetAngle : Number;
		private var __wallWidth : Number;
		private var __wallHeight : Number;
		private var __complete : Boolean;
		private var __pt : Point;
		private var __t : Number;

		public function SoftWallBoundsChecker(target : IMotionable)
		{
			super( target );

			__wallRatio = .4;
			__canvasRect = new Rectangle( 0, 0, ThreadConstants.MANAGER_WIDTH, ThreadConstants.MANAGER_HEIGHT );
			__innerRect = calculateInnerRect( __canvasRect );
			
			trace("INNER", __innerRect)
			__pt = new Point();
		}

		private function calculateInnerRect(_canvasRect : Rectangle) : Rectangle
		{
			__wallWidth = _canvasRect.width * ( __wallRatio / 2 );
			__wallHeight = _canvasRect.height * ( __wallRatio / 2 );

			return new Rectangle( __wallWidth, __wallHeight, _canvasRect.width - __wallWidth, _canvasRect.height - __wallHeight );
		}

		override public function checkBounds(x : Number, y : Number) : Point
		{
			if ( ! __innerRect.contains( x, y ) )
			{
				if (! __complete)
				{
					if (__targetAngle == -1)
					{
						__targetAngle = NumberUtils.unWrapAngle( _target.angle + 60 + Math.random() * 60 );
					}
					else
					{
						// var depthX : Number = ( __wallWidth - Math.abs( x ) ) / __wallWidth;
						// var depthY : Number = ( __wallHeight - Math.abs( y ) ) / __wallHeight;

						// __t += ( ( depthX + depthY ) / 2 ) / 100;
//						var addAmt : Number = ( __targetAngle - _target.angle) * .1;

						_target.angle += 1;

						if(Math.round(_target.angle) == __targetAngle)
						{
						
							__complete = true;
						}
					}
				}
			}
			else
			{
				__complete = false;
				__targetAngle = -1;
				__t = 0;
				
				__pt.x = x;
				__pt.y = y;
			}

			return __pt;
		}
	}
}
