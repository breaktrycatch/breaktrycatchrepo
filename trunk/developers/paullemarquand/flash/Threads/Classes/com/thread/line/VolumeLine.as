package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class VolumeLine extends AbstractLineStyle implements IDrawStyle 
	{
		public function VolumeLine() 
		{
			super(this);
		}
		
		override public function setStyle(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize * (_modifiers[0] * 100), _colorSupplier.currentColor, _target.lineAlpha * (1 - (_modifiers[0].volume)) );
		}
	}
}
