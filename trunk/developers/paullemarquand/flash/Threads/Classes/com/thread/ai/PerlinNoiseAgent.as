package com.thread.ai
{

	import flash.display.BitmapDataChannel;
	import com.breaktrycatch.color.ColorUtil;
	import com.core.ThreadCore;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import com.util.Randomizer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */
	public class PerlinNoiseAgent extends AbstractAgent implements IAgent
	{
		private static var noise : BitmapData;
		private var _offsets : Array;
		private var _offsetSpeed1 : Number = 2;
		private var _offsetSpeed2 : Number = -2;
		private var _range : Number = 10;
		private var _scaleSize : int = 1;

		public function PerlinNoiseAgent(target : IMotionable)
		{
			_offsets = [];
			_offsets.push( new Point() );
			_offsets.push( new Point() );
			super( target );
		}

		override public function run() : void
		{
			super.run();
			
			if (! noise)
			{
				makeSomeNoise();
			}

			var pixel : uint = noise.getPixel( _target.x / _scaleSize, _target.y / _scaleSize );
			var brightness : uint = (pixel / 0xFFFFFF)// - .5;
			trace("PerlinNoiseAgent.run(",[pixel.toString(16)],")");
			
			noise.setPixel(_target.x, _target.y, 0xff00ff)
			
			
			_target.angle = (brightness * (360)) //* .01;
		}

		private function makeSomeNoise() : void
		{
			if (! noise)
			{
				noise = new BitmapData( ThreadConstants.MANAGER_WIDTH / _scaleSize + 1, ThreadConstants.MANAGER_HEIGHT / _scaleSize + 1 );
				
				ThreadCore.stage.addChildAt( new Bitmap(noise), 0);
			}

			noise.perlinNoise( ThreadConstants.MANAGER_WIDTH / 10, ThreadConstants.MANAGER_HEIGHT / 10, 1, 1000, false, true, 7, true, _offsets );

			_offsets[0].x += _offsetSpeed1;
			_offsets[0].y += _offsetSpeed1;

			_offsets[1].x += _offsetSpeed2;
			_offsets[1].y += _offsetSpeed2;
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer();
			randomizer.addRule( Number, "range", -40, 40 );
			randomizer.randomize( this );
		}

		public function get range() : Number
		{
			return _range;
		}

		public function set range(range : Number) : void
		{
			_range = range;
		}
	}
}