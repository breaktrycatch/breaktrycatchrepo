package com.thread.ai 
{
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import com.util.NumberUtils;

	/**
	 * @author Paul
	 */
	public class FollowAgent extends AbstractAgent implements IAgent 
	{
		protected var _index : int;
		protected var _worldAgents : Array;
		private var _ctr : Number;
		private var _followTarget : IMotionable;
		

		public function FollowAgent(target : IMotionable)
		{
			super( target, this );
			_ctr = 0;
		}

		override public function randomize() : void
		{
		}

		override public function update() : void
		{
			var dist : Number = getDistance();
			var angle : Number = getAngle();
			
			//_target.angle += NumberUtils.radToDegree( deltaAngle ) / (1 + _index * .3);
			//_target.angle += NumberUtils.radToDegree( deltaAngle ) / (1 + _index * .01);
			//_target.angle += NumberUtils.radToDegree( deltaAngle ) / (1 + ( 1 - dist / ThreadConstants.MANAGER_WIDTH / 2)) * 3;
			_target.angle += NumberUtils.radToDegree( angle ) / (1 + ( 1 - dist / ThreadConstants.MANAGER_WIDTH / 2)) * ((_index / _worldAgents.length) * 3);
			_ctr += 1;
		}
		
		protected function getDistance() : Number
		{
			var nX : Number = _followTarget.x - _target.x;
			var nY : Number = _followTarget.y - _target.y;
			return Math.sqrt( nX * nX + nY * nY );
		}
		
		protected function getAngle() : Number
		{
			var nX : Number = _followTarget.x - _target.x;
			var nY : Number = _followTarget.y - _target.y;
			var rad : Number = Math.atan2( nY, nX );
			var angle : Number = rad - NumberUtils.degreeToRad( _target.angle ) % 360;
			while(angle < -Math.PI) angle += 2 * Math.PI;
			while(angle > Math.PI) angle -= 2 * Math.PI;
			return angle;
		}

		override public function setModifiers(...args) : void
		{
			_worldAgents = args[0];
			_index = args[1];
			_target.speed = _target.initialSpeed * ((1 - (_index / _worldAgents.length)) * .2 + .8);
			_followTarget = ( _index > 0) ? (_worldAgents[_index - 1].data) : (_worldAgents[_worldAgents.length - 1].data);
		}
	}
}
