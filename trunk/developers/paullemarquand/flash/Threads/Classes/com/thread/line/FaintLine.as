package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.line.AlphaLine;
	import com.thread.vo.ILineStyleable;
	import com.util.Randomizer;

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

		public function FaintLine(target : ILineStyleable, colorSupplier : IColorSupplier, maxAlpha : Number = .5) 
		{
			this.maxAlpha = maxAlpha;
			super(target, colorSupplier);
		}

		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize, _colorSupplier.currentColor, _maxAlpha * _target.lineAlpha * (_index / _worldAgents.length) );
		}

		override public function randomize() : void
		{
			var randomizer : Randomizer = new Randomizer( );
			randomizer.addRule( Number, "maxAlpha", .05, .2 );
			randomizer.randomize( this );
		}
	}
}
