package com.thread.ai
{

	import com.thread.Thread;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import com.thread.vo.IRandomizable;
	import com.util.NumberUtils;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Paul
	 */
	public class AbstractAgent implements IAgent, IRandomizable
	{
		protected var _target : IMotionable;
		protected var _index : int;
		protected var _worldAgents : Array;
		private var _ctr : Number;
		private var _followTarget : IMotionable;
		private var _isLeader : Boolean;

		public function AbstractAgent(target : IMotionable, enforcer : AbstractAgent)
		{
			enforcer = null;
			_target = target;
			_ctr = 0;
		}

		public function update() : void
		{
			var dist : Number = getDistance();
			var angle : Number = getAngle();

			// This is the money equation!
			_target.angle += NumberUtils.radToDegree( angle ) / (1 + ( 1 - dist / ThreadConstants.MANAGER_WIDTH / 2)) * ((_index / _worldAgents.length) * Math.PI);
			_ctr += 1;

			if (_isLeader )
			{
				run();
			}
		}

		public function run() : void
		{
			updateFollowTarget();
		}

		public function randomize() : void
		{
			throw new IllegalOperationError( "randomize() not implemented in" + this );
		}

		public function setModifiers(...args) : void
		{
			var spd : Number = 0;
			_worldAgents = args[0];
			_index = args[1];
			_target.speed = _target.initialSpeed * ((1 - (_index / _worldAgents.length)))// * (1 - spd) + spd);
			_isLeader = (_index == 0);

			updateFollowTarget();
		}

		public function set target(t : IMotionable) : void
		{
			_target = t;
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
			while (angle < -Math.PI) angle += 2 * Math.PI;
			while (angle > Math.PI) angle -= 2 * Math.PI;
			return angle;
		}

		private function updateFollowTarget() : void
		{
			var target : Thread = ( _isLeader) ? (_worldAgents[Math.floor( _worldAgents.length * Math.random() )]) : (_worldAgents[_index - 1]);
			_followTarget = target.data;
		}
	}
}
