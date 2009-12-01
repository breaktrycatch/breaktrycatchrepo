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
			drawTarget.graphics.lineStyle( _target.lineSize * (_index / _worldAgents.length), _colorSupplier.currentColor, _target.lineAlpha * (_index / _worldAgents.length) );
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
