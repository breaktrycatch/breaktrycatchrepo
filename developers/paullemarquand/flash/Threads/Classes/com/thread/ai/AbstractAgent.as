package com.thread.ai 
{
	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;
	import com.thread.vo.IRandomizable;

	import flash.errors.IllegalOperationError;

	/**
	 * @author Paul
	 */
	public class AbstractAgent implements IAgent, IRandomizable
	{
		protected var _target : IMotionable;	

		public function AbstractAgent(target : IMotionable, enforcer : AbstractAgent) 
		{
			enforcer = null;
			_target = target;
		}

		public function update() : void
		{
			throw new IllegalOperationError( "update() not implemented in" + this );
		}

		public function randomize() : void
		{
			throw new IllegalOperationError( "randomize() not implemented in" + this );
		}

		public function setModifiers(...args) : void
		{
			
		}

		public function set target(t : IMotionable) : void
		{
			_target = t;
		}
	}
}
