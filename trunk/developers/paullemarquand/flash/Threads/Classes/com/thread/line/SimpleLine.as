package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.motion.ILineStyleable;
	
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
