package com.thread.color
{

	import com.breaktrycatch.collection.util.ArrayExtensions;
	import com.breaktrycatch.color.ColorObject;
	import com.breaktrycatch.color.ColorSpaceTransformations;
	import com.breaktrycatch.color.ColorUtil;
	import com.thread.vo.IRandomizable;
	import com.util.CloneUtil;
	import com.util.Randomizer;

	/**
	 * @author Paul
	 */
	public class GradientColorSupplier implements IColorSupplier, IRandomizable
	{
		protected var _colors : Array;
		private var _currColor : Number;
		private var _oldColor : Number;
		private var _nextColor : Number;
		private var _currColorIndex : Number;
		private var _framesPerColor : int;
		private var _colCtr : int;
		private var _defaultColours : Array = [ 0xA34C19, 0x548582, 0x9FC7B2, 0xFCF9CA, 0x122622, 0x2C5940, 0x998755, 0xFFC869 ];
//		private var _defaultColours : Array = [0xFFFF9D,0xBEEB9F,0x79BD8F,0x0A3D39,0xC1A24];
//		private var _defaultColours : Array = [ 0xFF4D41, 0xF2931F, 0xE5CA21, 0x91B221, 0x1E8C65 ];

		// 0 - 255
		private var _variation : int = 20;

		public function GradientColorSupplier(colors : Array = null, framesPerColor : int = 100)
		{
			_colors = (colors == null) ? (_defaultColours) : (colors);
			_framesPerColor = framesPerColor;
			
			for (var i : int = 0; i < _colors.length; i++)
			{
				var col : ColorObject = ColorSpaceTransformations.HEXtoRGB( _colors[i] );
				col.variate( _variation );
				_colors[i] = col.hex;
			}
			
			_currColor = ArrayExtensions.randomElement( _colors );
//			_currColor = _colors[0];

			activeColorIndex = _colors.indexOf( _currColor );
		}

		public function update() : void
		{
			_colCtr++;
			checkBounds();
			_currColor = ColorUtil.blendRGB( _oldColor, _nextColor, _colCtr / _framesPerColor );
		}

		protected function set activeColorIndex(i : int) : void
		{
			_currColorIndex = i;
			_oldColor = _currColor;
			_nextColor = _colors[i % _colors.length];
			_colCtr = 0;
		}

		private function checkBounds() : void
		{
			if (_colCtr > _framesPerColor)
			{
				_oldColor = _currColor;
				_currColorIndex++;
				_nextColor = _colors[_currColorIndex % _colors.length];
				_colCtr = 0;
			}
		}

		public function get currentColor() : uint
		{
			return _currColor;
		}

		public function get framesPerColor() : uint
		{
			return _framesPerColor;
		}

		public function set framesPerColor(n : uint) : void
		{
			_framesPerColor = n;
		}

		public function copy() : IColorSupplier
		{
			return CloneUtil.clone( this );
		}

		public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer();
			randomizer.addRule( uint, "framesPerColor", 300, 800 );
			randomizer.randomize( this );
		}
	}
}
