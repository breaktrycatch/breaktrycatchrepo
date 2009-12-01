package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import com.util.NumberUtils;

	/**	 * @author plemarquand	 */	public class GroupFollowAgent extends AbstractAgent implements IAgent 
	{
		private var _followTarget : IMotionable;
		private var _speedOffset : Number;
		
		public static const GROUP_SIZE : int = 10;
		public function GroupFollowAgent(target : IMotionable, followTarget : IMotionable, speedOffset : Number)
		{
			_followTarget = followTarget;
			_speedOffset = speedOffset;			super( target, this );		}

		override public function update() : void
		{
			var nX : Number = _followTarget.x - _target.x;
			var nY : Number = _followTarget.y - _target.y;
			var rad : Number = Math.atan2( nY, nX );
			var dist : Number = Math.sqrt( nX * nX + nY * nY );
				
			var deltaAngle : Number = rad - NumberUtils.degreeToRad( _target.angle ) % 360;
			while(deltaAngle < -Math.PI) deltaAngle += 2 * Math.PI;
			while(deltaAngle > Math.PI) deltaAngle -= 2 * Math.PI;
			
			_target.angle += NumberUtils.radToDegree( deltaAngle ) / (1 + ( 1 - dist / ThreadConstants.MANAGER_WIDTH / 2)) * 3;
			//_target.angle += NumberUtils.radToDegree( deltaAngle ) / (1 + ( 1 - dist / ThreadConstants.MANAGER_WIDTH / 2)) * (_speedOffset);

			_target.speed = _target.initialSpeed * ((1 - _speedOffset) * .2 + .8);		}

		override public function setModifiers(...args : *) : void
		{
		}

		override public function randomize() : void
		{		}
	}}