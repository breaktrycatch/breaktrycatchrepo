package com.thread.ai
{

	import com.thread.vo.ThreadDataVO;
	import flash.display.BitmapData;

	/**
	 * @author plemarquand
	 */
	public class ScrollFixedBottomAgent extends AbstractAgent implements IAgent
	{
		private var _canvas : BitmapData;
		private var _ctrS : Number = 0;
		private var _ctrC : Number = 0;

		public function ScrollFixedBottomAgent(target : ThreadDataVO, canvas : BitmapData)
		{
			_canvas = canvas;
			super( target );
		}

		override public function run() : void
		{
			_ctrS += .0001;
			_ctrC += .0001;
			
			_target.angle += Math.sin( _ctrS ) * 13;
			_target.angle += Math.cos( _ctrC ) * 23;
			
			super.run();

		}

		override public function randomize() : void
		{
		}
	}
}
