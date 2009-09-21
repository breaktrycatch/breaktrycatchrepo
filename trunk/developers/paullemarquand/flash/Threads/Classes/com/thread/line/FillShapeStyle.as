package com.thread.line 
{	import com.thread.line.AbstractLineStyle;
	import com.thread.line.IDrawStyle;

	import flash.display.Sprite;

	/**	 * @author plemarquand	 */	public class FillShapeStyle extends AbstractLineStyle implements IDrawStyle 
	{		public function FillShapeStyle()
		{			super( this );		}
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.beginFill( _colorSupplier.currentColor, 1);		}

		override public function postDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.endFill();		}
	}}