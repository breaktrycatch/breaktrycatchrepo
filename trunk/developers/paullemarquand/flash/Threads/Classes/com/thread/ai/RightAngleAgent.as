package com.thread.ai 
{
	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;
	import com.util.Randomizer;

	/**
	{
		private var _ctr : int = 0;
		private var _switchInterval : int;
		public function RightAngleAgent(target : IMotionable)
		{
			updateSwitchInterval();

		override public function update() : void
		{
			_ctr++;
			
			if(_ctr % _switchInterval == 0)
			{
				updateSwitchInterval();
				_target.angle += ((Math.random() < .5) ? (90) : (-90));
		}
		
		private function updateSwitchInterval():void
		{
			_switchInterval = 20 + Math.round(Math.random() * 100);
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.randomize( this );
	}