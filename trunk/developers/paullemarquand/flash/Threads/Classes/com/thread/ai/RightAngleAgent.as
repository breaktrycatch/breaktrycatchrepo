package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.motion.IMotionable;
	import com.util.Randomizer;

	/**	 * @author plemarquand	 */	public class RightAngleAgent extends AbstractAgent implements IAgent 
	{
		private var _ctr : int = 0;
		private var _switchInterval : int;
		public function RightAngleAgent(target : IMotionable)
		{
			updateSwitchInterval();			super( target, this );		}

		override public function update() : void
		{
			_ctr++;
			
			if(_ctr % _switchInterval == 0)
			{
				updateSwitchInterval();
				_target.angle += ((Math.random() < .5) ? (90) : (-90));			}
		}
		
		private function updateSwitchInterval():void
		{
			_switchInterval = 20 + Math.round(Math.random() * 100);
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.randomize( this );		}
	}}