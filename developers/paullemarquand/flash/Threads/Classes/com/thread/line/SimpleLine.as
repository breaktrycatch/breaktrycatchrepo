package com.thread.line 
{
	import flash.display.Sprite;

	/**
	 * @author Paul
	 */
	public class SimpleLine extends AbstractLineStyle implements IDrawStyle 
	{
		public function SimpleLine() 
		{
			super(this);
		}
		
		override public function setStyle(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize, _colorSupplier.currentColor, _target.lineAlpha );
		}
	}
}
