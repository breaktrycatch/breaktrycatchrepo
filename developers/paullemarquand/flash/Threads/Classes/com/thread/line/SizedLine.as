package com.thread.line 
{
	import com.thread.Thread;
	import com.thread.line.AbstractLineStyle;
	import com.thread.line.IDrawStyle;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class SizedLine extends AbstractLineStyle implements IDrawStyle 
	{
		private var _index : int;
		private var _worldAgents : Vector.<Thread>;
		
		public function SizedLine()
		{
			super( this );
		}
		
		override public function preDraw(drawTarget : Sprite) : void
		{
			drawTarget.graphics.lineStyle( _target.lineSize * (_index / _worldAgents.length), _colorSupplier.currentColor, _target.lineAlpha );
		}
		
		override public function setModifiers(...args) : void
		{
			_worldAgents = args[0];
			_index = args[1];
		}
	}
}
