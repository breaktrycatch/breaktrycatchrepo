package com.thread.line 
{
	import com.thread.Thread;
	import com.thread.line.AbstractLineStyle;
	import com.thread.line.IDrawStyle;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class AlphaLine extends AbstractLineStyle implements IDrawStyle 
	{
		protected var _index : int;
		protected var _worldAgents : Vector.<Thread>;
		
		public function AlphaLine()
		{
			super( this );
		}
		
		override public function setStyle(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize, _colorSupplier.currentColor, _target.lineAlpha * (_index / _worldAgents.length) );
		}
		
		override public function setModifiers(...args) : void
		{
			_worldAgents = args[0];
			_index = args[1];
		}
	}
}
