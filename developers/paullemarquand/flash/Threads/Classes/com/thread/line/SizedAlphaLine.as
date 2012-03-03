package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.line.AbstractLineStyle;
	import com.thread.line.IDrawStyle;
	import com.thread.vo.ILineStyleable;

	import flash.display.Sprite;

	/**
	 * @author Paul
	 */
	public class SizedAlphaLine extends AbstractLineStyle implements IDrawStyle 
	{
		private var _index : int;
		private var _worldAgents : Array;
		
		public function SizedAlphaLine(target : ILineStyleable, colorSupplier : IColorSupplier) 
		{
			super(target, colorSupplier, this);
		}
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			var size : Number = _target.lineSize * (1 - (_index / _worldAgents.length));
			var color : Number = _colorSupplier.currentColor;
			var alpha : Number = _target.lineAlpha * (_index / _worldAgents.length);
//			drawTarget.graphics.lineStyle( size, color, alpha );
			drawTarget.graphics.lineStyle( size, color, _target.lineAlpha );
		}

		override public function postDraw(drawTarget : Sprite) : void
		{
		}

		override public function setModifiers(...args) : void
		{
			_worldAgents = args[0];
			_index = args[1];
		}

		override public function randomize() : void
		{
			// do nothing
		}
	}
}
