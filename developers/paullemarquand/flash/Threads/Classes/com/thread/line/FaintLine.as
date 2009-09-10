package com.thread.line 
{
	import com.thread.line.AlphaLine;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class FaintLine extends AlphaLine 
	{
		private var _maxAlpha : Number = .5;

		public function get maxAlpha() : Number
		{
			return _maxAlpha;	
		}

		public function set maxAlpha(n : Number) : void
		{
			_maxAlpha = n;	
		}

		public function FaintLine()
		{
			super( );
		}

		override public function setStyle(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize, _colorSupplier.currentColor, _maxAlpha * _target.lineAlpha * (_index / _worldAgents.length) );
		}
	}
}
