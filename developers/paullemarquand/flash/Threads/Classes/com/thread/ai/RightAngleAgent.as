package com.thread.ai
{

	import com.util.NumberUtils;
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;
	import com.util.Randomizer;

	/**	 * @author plemarquand	 */
	public class RightAngleAgent extends AbstractAgent implements IAgent
	{
		private var _ctr : int = 0;
		private var _switchInterval : int;
		private const _angleIncrement : Number = 90;
		
		private var _intervals : Array = [100, 150, 200, 250, 200, 150, 100];
		private var _intervalCounter : int = 0;
		
		public function RightAngleAgent(target : IMotionable)
		{
			updateSwitchInterval();
			super( target );
		}

		override public function run() : void
		{
			_ctr++;

			if (_ctr % _switchInterval == 0)
			{
				updateSwitchInterval();
				_target.angle += ((Math.random() < .5) ? (_angleIncrement) : (-_angleIncrement));
			}
			super.run();
		}

		private function updateSwitchInterval() : void
		{
			_intervalCounter = (_intervalCounter + 1) % _intervals.length;
//			_switchInterval = _intervals[_intervalCounter];
			_switchInterval = NumberUtils.randomBetween(10, 100);
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer();
			randomizer.randomize( this );
		}
	}
}