package com.thread.ai 
{
	import com.thread.constant.ThreadConstants;	
	import com.util.NumberUtils;	
	import com.thread.motion.IMotionable;	
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;

	import flash.display.BitmapData;	

	/**
	 * @author Paul
	 */
	public class BitmapFollowAgent extends SimpleAgent implements IAgent 
	{
		private var _data : BitmapData;

		public function BitmapFollowAgent(target : IMotionable, data : BitmapData)
		{
			super( target );
			_data = data;
			findStartPosition( );
		}

		private function findStartPosition() : void
		{
			var foundEdge : Boolean = false;
			var nX : Number;
			var nY : Number;
			var r : Number = 1;
			
			do
			{
				for (var i : Number = 0; i < Math.PI * 2 ; i += .5) 
				{
					nX = _target.x + Math.cos( NumberUtils.degreeToRad( i ) ) * r;
					nY = _target.y + Math.sin( NumberUtils.degreeToRad( i ) ) * r;
					foundEdge = _data.getPixel( nX, nY ) != 0;
					if(foundEdge)
					{
						break;
					}
				}
				r += 1;
			} while(!foundEdge && r < ThreadConstants.MANAGER_WIDTH / 2);
			
			_target.x = nX;
			_target.y = nY;
		}

		override public function update() : void
		{
			var currPosCol : uint = _data.getPixel( _target.x, _target.y );
			if(currPosCol != 0)
			{
				// we're where we need to be
				var castDistance : Number = 1;
				var nX : Number;
				var nY : Number;
				var foundEdge : Boolean = false;
				do
				{
					nX = _target.x + Math.cos( NumberUtils.degreeToRad( _target.angle ) ) * castDistance;
					nY = _target.y + Math.sin( NumberUtils.degreeToRad( _target.angle ) ) * castDistance;
					foundEdge = _data.getPixel( nX, nY ) == 0;
					castDistance += 1;
				} 
				while(!foundEdge);
				
				if(castDistance < 10)
				{
					var rad : Number = NumberUtils.degreeToRad( _target.angle );
					var aX : Number;
					var aY : Number;
					var r : Number = 2;
					if(Math.random( ) < .5)
					{
						for (var i : Number = rad; i < rad + Math.PI * 2 ; i += .1) 
						{
							r = 2;
							aX = nX + Math.cos( i ) * r;
							aY = nY + Math.sin( i ) * r;
							if(_data.getPixel( aX, aY ) != 0)
							{
								_target.angle += ( NumberUtils.radToDegree( i ) - _target.angle); // castDistance; // FACTOR in DISTANCE to make angle changes less abrupt
							}
						}
					}
				}
			}
		}
	}
}
