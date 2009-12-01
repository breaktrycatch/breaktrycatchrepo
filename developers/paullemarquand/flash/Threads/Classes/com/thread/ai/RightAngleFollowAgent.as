package com.thread.ai 
{	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;
	import com.util.NumberUtils;

	/**	 * @author plemarquand	 */	public class RightAngleFollowAgent extends UniqueLeaderFollowAgent implements IAgent 
	{
		private var _turnThreshold : Number = 45;
		private var _turnAmount : Number = 90;
		private var _distThreshold : Number = 50;

		
		public function RightAngleFollowAgent(target : IMotionable)
		{			super( target );		}

		override public function update() : void
		{
			if(_index == 0)
			{
				super.update( );
			}
			else
			{
				var angle : Number = getAngle( );
				var degrees : Number = NumberUtils.radToDegree( angle );
				var dist : Number = getDistance();
				
				if((degrees > _turnThreshold || degrees < -_turnThreshold) && dist > _distThreshold)
				{
					_target.angle += _turnAmount * NumberUtils.sign( degrees );
				}
			}
		}

		override public function randomize() : void
		{		}
	}}