package com.thread.color 
{
	import com.breaktrycatch.color.ColorUtil;
	import com.util.CloneUtil;		

	/**
	 * @author Paul
	 */
	public class GradientColorSupplier implements IColorSupplier
	{
		protected var _colors 		: Array;
		private var _currColor		: Number;
		private var _oldColor 		: Number;
		private var _nextColor 		: Number;
		private var _currColorIndex : Number;
		private var _framesPerColor 		: int;
		private var _colCtr			: int;
		
		public function GradientColorSupplier(colors : Array, framesPerColor : int = 10) 
		{
			trace("COLORS: " + colors);
			_colors = colors;
			_framesPerColor = framesPerColor;
			_currColor = _colors[0];
			activeColorIndex = 0;
		}

		public function update() : void
		{
			_colCtr++;
			checkBounds();
			_currColor = ColorUtil.blendRGB( _oldColor, _nextColor, _colCtr / _framesPerColor );
		}
		
		protected function set activeColorIndex(i:int):void
		{
			_currColorIndex = i;
			_oldColor = _currColor;
			_nextColor = _colors[i % _colors.length];
			_colCtr = 0;
		}
		
		private function checkBounds():void
		{
			if(_colCtr > _framesPerColor) 
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
			return CloneUtil.clone(this);
		}
	}
}
