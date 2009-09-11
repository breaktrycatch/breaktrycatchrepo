package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.motion.IMotionable;
	import com.util.Randomizer;

	/**	 * @author plemarquand	 */	public class RightAngleAgent extends AbstractAgent implements IAgent 
	{
		private var _ctr : int = 0;
		public function RightAngleAgent(target : IMotionable)
		{			super( target, this );		}

		override public function update() : void
		{
			_ctr++;
			
			if(_ctr % 100 == 0)
			{
				_target.angle += ((Math.random() < .5) ? (45) : (-45));			}
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.randomize( this );		}
	}}