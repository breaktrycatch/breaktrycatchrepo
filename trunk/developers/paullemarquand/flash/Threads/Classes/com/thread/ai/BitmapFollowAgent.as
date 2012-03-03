package com.thread.ai 
{

	import com.core.ThreadCore;
	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author Paul
	 */
	public class BitmapFollowAgent extends AbstractAgent implements IAgent 
	{
		private var _data : BitmapData;
		private static var _added : Boolean;
		private var _foundStartPosition : Boolean;

		public function BitmapFollowAgent(target : IMotionable, data : BitmapData)
		{
			super( target );
			_data = data;
			
			if(!_added)
			{
				_added = true;
				var bmp : Bitmap = new Bitmap( _data );
				bmp.alpha = .5;
				bmp.width = ThreadConstants.MANAGER_WIDTH;
				bmp.height = ThreadConstants.MANAGER_HEIGHT
				ThreadCore.stage.addChild( bmp );
			}
			//findStartPosition( );
		}

		private function findStartPosition() : void
		{
			_foundStartPosition = true;
			
			var currPosCol : uint = _data.getPixel( (_target.x / ThreadConstants.MANAGER_WIDTH) * _data.width, (_target.y / ThreadConstants.MANAGER_HEIGHT) * _data.height );
			while(currPosCol < 0xffffff / 2)
			{
				_target.x = Math.random() * ThreadConstants.MANAGER_WIDTH;
				_target.y = Math.random() * ThreadConstants.MANAGER_HEIGHT;
				currPosCol = _data.getPixel( (_target.x / ThreadConstants.MANAGER_WIDTH) * _data.width, (_target.y / ThreadConstants.MANAGER_HEIGHT) * _data.height );
			}
			
			for (var i : int = 0; i < _worldAgents.length; i++) {
				var thread : Thread = _worldAgents[i];
				thread.data.x = thread.data.prevX = _target.x;
				thread.data.y = thread.data.prevY = _target.y;
				
			}
		}

		override public function run() : void
		{
			super.run();
			
			if(!_foundStartPosition)
			{
				findStartPosition();
			}
			
			var currPosCol : uint = _data.getPixel( (_target.x / ThreadConstants.MANAGER_WIDTH) * _data.width, (_target.y / ThreadConstants.MANAGER_HEIGHT) * _data.height );
			
			trace("BitmapFollowAgent.run(",[currPosCol.toString(16)],")");
			
			if(currPosCol < 0xffffff / 2)
			{
				_target.angle += 180 + Math.random() * 10 - Math.random() * 10;
			}
			
//			if(currPosCol != 0)
//			{
//				// we're where we need to be
//				var castDistance : Number = 1;
//				var nX : Number;
//				var nY : Number;
//				var foundEdge : Boolean = false;
//				do
//				{
//					nX = _target.x + Math.cos( NumberUtils.degreeToRad( _target.angle ) ) * castDistance;
//					nY = _target.y + Math.sin( NumberUtils.degreeToRad( _target.angle ) ) * castDistance;
//					foundEdge = _data.getPixel( nX, nY ) == 0;
//					castDistance += 1;
//				} 
//				while(!foundEdge);
//				
//				if(castDistance < 10)
//				{
//					var rad : Number = NumberUtils.degreeToRad( _target.angle );
//					var aX : Number;
//					var aY : Number;
//					var r : Number = 2;
//					if(Math.random( ) < .5)
//					{
//						for (var i : Number = rad; i < rad + Math.PI * 2 ; i += .1) 
//						{
//							r = 2;
//							aX = nX + Math.cos( i ) * r;
//							aY = nY + Math.sin( i ) * r;
//							if(_data.getPixel( aX, aY ) != 0)
//							{
//								_target.angle += ( NumberUtils.radToDegree( i ) - _target.angle); // castDistance; // FACTOR in DISTANCE to make angle changes less abrupt
//							}
//						}
//					}
//				}
//			}
		}

	}
}
