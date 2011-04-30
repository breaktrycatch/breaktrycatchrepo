package com.thread.line
{

	import com.thread.color.IColorSupplier;
	import com.thread.vo.ILineStyleable;
	import flash.display.Sprite;

	/**
	 * @author plemarquand
	 */
	public class FaintSizingLine extends FaintLine implements IDrawStyle
	{
		
		
		public function FaintSizingLine(target : ILineStyleable, colorSupplier : IColorSupplier)
		{
			super( target, colorSupplier );
		}
		
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( maxAlpha * _target.lineSize * (1 - (_index / _worldAgents.length ) ), _colorSupplier.currentColor, maxAlpha * _target.lineAlpha * (_index / _worldAgents.length) );
		}
	}
}
