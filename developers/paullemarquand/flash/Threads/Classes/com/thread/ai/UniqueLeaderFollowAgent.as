package com.thread.ai 
{	import com.thread.ai.FollowAgent;
	import com.thread.vo.IMotionable;

	/**	 * @author plemarquand	 */	public class UniqueLeaderFollowAgent extends FollowAgent implements IAgent
	{		private var _driver : PerlinNoiseAgent;
		private var _driverFreq : int = 10;
		private var _initSpeed : Number;

		public function UniqueLeaderFollowAgent(target : IMotionable)
		{			super( target );		}

		override public function update() : void
		{
			if(_index == 0)
			{
				_driver.update();
			}
			else
			{
				super.update( );
			}
		}

		override public function setModifiers(...args) : void
		{
			super.setModifiers.apply(this, args );
			
			if(_index % _driverFreq == 0 && !_driver)
			{
				_driver = new PerlinNoiseAgent(_target);
			}
			
			if(!_initSpeed)
			{
				_initSpeed = _target.speed;
			}
			
			_target.speed = (1-(_index / _worldAgents.length)) * _initSpeed;
		}
	}}