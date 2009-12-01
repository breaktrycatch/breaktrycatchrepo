package com.thread.line 
{
	import com.thread.color.IColorSupplier;
	import com.thread.vo.ILineStyleable;
	import com.thread.vo.IRandomizable;

	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Paul
	 */
	public class AbstractLineStyle implements IDrawStyle, IRandomizable
	{
		protected var _target : ILineStyleable;
		protected var _colorSupplier : IColorSupplier;
		protected var _modifiers : Array;

		public function AbstractLineStyle(target : ILineStyleable, colorSupplier : IColorSupplier, enforcer : AbstractLineStyle) 
		{
			enforcer = null;
			this.target = target;
			this.colorSupplier = colorSupplier;
		}

		public function set target(v : ILineStyleable) : void
		{
			_target = v;
		}

		public function set colorSupplier(color : IColorSupplier) : void
		{
			_colorSupplier = color;
		}

		public function setModifiers(...args) : void
		{
			_modifiers = args;
		}
		
		public function preDraw(drawTarget : Sprite) : void
		{
			throw new IllegalOperationError( "preDraw() not implemented in" + this );
		}
		
		public function postDraw(drawTarget : Sprite) : void
		{
			throw new IllegalOperationError( "postDraw() not implemented in" + this );
		}
		
		public function randomize() : void
		{
			throw new IllegalOperationError( "randomize() not implemented in" + this );
		}
	}
}

internal class AbstractEnforcer 
{
}