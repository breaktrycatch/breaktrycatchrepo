package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.vo.ILineStyleable;

	import flash.display.Sprite;

	/**
	 * @author Paul
	 */
	public class SimpleLine extends AbstractLineStyle implements IDrawStyle 
	{
		public function SimpleLine(target : ILineStyleable, colorSupplier : IColorSupplier) 
		{
			super(target, colorSupplier, this);
		}
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize, _colorSupplier.currentColor, _target.lineAlpha );
		}

		override public function postDraw(drawTarget : Sprite) : void
		{
			// do nothing
		}

		override public function randomize() : void
		{
			// do nothing
		}
	}
}
