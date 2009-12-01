package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IMotionable;
	import com.util.Randomizer;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class PerlinNoiseAgent extends AbstractAgent implements IAgent 
	{
		private static var noise : BitmapData;
		private var _index : int;
		private var _worldAgents : Array;
		private var _offsets : Array;
		private var _offsetSpeed1 : Number = 2;
		private var _offsetSpeed2 : Number = -2;
		private var _range : Number = 10;
		private var _scaleSize : int = 2;
		
		
		public function PerlinNoiseAgent(target : IMotionable)
		{
			_offsets = [];
			_offsets.push( new Point() );
			_offsets.push( new Point() );			super( target, this );		}

		override public function update() : void
		{
			if(!noise || _index == 0)
			{
				createNoise( );			}
			
			var pixel : uint = noise.getPixel( _target.x / _scaleSize, _target.y / _scaleSize);
			var brightness : Number = pixel / 0xFFFFFF;
			_target.angle = brightness * (360 + range);
		}

		private function createNoise() : void
		{
			if(!noise)
			{
				noise = new BitmapData( ThreadConstants.MANAGER_WIDTH / _scaleSize + 1, ThreadConstants.MANAGER_HEIGHT / _scaleSize + 1);
			}
			
			noise.perlinNoise( 180, 180, 2, 1000, false, true, 10, true, _offsets );
			
			_offsets[0].x += _offsetSpeed1;
			_offsets[0].y += _offsetSpeed1;
			
			_offsets[1].x += _offsetSpeed2;
			_offsets[1].y += _offsetSpeed2;
		}

		override public function setModifiers(...args : *) : void
		{
		
			_worldAgents = args[0];
			_index = args[1];
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
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
	}}