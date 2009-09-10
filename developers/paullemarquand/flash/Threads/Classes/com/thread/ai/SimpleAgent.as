package com.thread.ai 
{
	import com.thread.motion.IMotionable;	
	import com.util.Randomizer;	
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;

	/**
	 * @author Paul
	 */
	public class SimpleAgent extends AbstractAgent implements IAgent 
	{
		private var _ctr : int;
		private var _curlSpeed : Number = 500;
		private var _curlTightness : Number = 3;

		public function SimpleAgent(target : IMotionable)
		{
			super( target, this );
			_ctr = 0;
		}

		override public function update() : void
		{
			//_target.angle += Math.cos( _ctr / _curlSpeed ) * _curlTightness * Math.sin( _ctr / _curlSpeed ) * _curlTightness;
			//_target.angle += Math.cos( _ctr / _curlSpeed );
			_target.angle += .1;
			_ctr++;
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "curlSpeed", 10, 10);
			randomizer.addRule( Number, "curlTightness", 1, 1);
		}
		
		public function get curlSpeed() : Number
		{
			return _curlSpeed;
		}

		public function get curlTightness() : Number
		{
			return _curlTightness;
		}

		public function set curlSpeed(n : Number) : void
		{
			_curlSpeed = n;	
		}

		public function set curlTightness(n : Number) : void
		{
			_curlTightness = n;	
		}
	}
}
