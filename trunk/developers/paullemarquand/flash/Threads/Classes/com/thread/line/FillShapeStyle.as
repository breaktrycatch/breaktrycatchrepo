package com.thread.line 
{	import com.thread.color.IColorSupplier;
	import com.thread.line.AbstractLineStyle;
	import com.thread.line.IDrawStyle;
	import com.thread.vo.ILineStyleable;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class FillShapeStyle extends AbstractLineStyle implements IDrawStyle 
	{		public function FillShapeStyle(target : ILineStyleable, colorSupplier : IColorSupplier) 
		{
			super(target, colorSupplier, this);
		}
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.beginFill( _colorSupplier.currentColor, _target.lineAlpha);		}

		override public function postDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.endFill();		}

		override public function randomize() : void
		{
			// do nothing
		}
	}}