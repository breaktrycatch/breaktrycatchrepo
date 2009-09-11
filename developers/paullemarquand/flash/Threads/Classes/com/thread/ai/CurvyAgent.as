package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.motion.IMotionable;
	import com.util.Randomizer;

	/**	 * @author plemarquand	 */	public class CurvyAgent extends AbstractAgent implements IAgent
	{
		private var _curlSpeed : Number = 500;
		private var _curlTightness : Number = 3;
		private var _ctr : int = 0;		public function CurvyAgent(target : IMotionable)
		{			super( target, this );		}

		override public function update() : void
		{
			_target.angle += Math.cos( _ctr / _curlSpeed ) * _curlTightness * Math.sin( _ctr / _curlSpeed ) * _curlTightness;
//			_target.angle += Math.cos( _ctr / _curlSpeed );
//			_target.angle += .1;

		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "curlSpeed", 10, 10);
			randomizer.addRule( Number, "curlTightness", 1, 1 );
			randomizer.randomize( this );
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
	}}