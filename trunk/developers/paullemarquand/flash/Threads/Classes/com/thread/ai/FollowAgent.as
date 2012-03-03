package com.thread.ai
{

	import com.thread.vo.IMotionable;

	/**
	 * @author Paul
	 */
	public class FollowAgent extends AbstractAgent implements IAgent
	{
		private static const SWITCH_PROBABBILITY : Number = .01;

		public function FollowAgent(target : IMotionable)
		{
			super( target );
		}

		override public function randomize() : void
		{
		}

		override public function run() : void
		{
			if (Math.random() < SWITCH_PROBABBILITY)
			{
				_target.angle += ((Math.random() < .5) ? (-1) : (1)) * 90;
				super.run();
			}
		}
	}
}
