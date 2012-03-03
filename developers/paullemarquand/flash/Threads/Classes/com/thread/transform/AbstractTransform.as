package com.thread.transform
{

	import com.thread.vo.IPositionable;
	import com.thread.vo.IRandomizable;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Paul
	 */
	public class AbstractTransform implements IDrawTransform, IRandomizable
	{
		public function AbstractTransform()
		{
			randomize();
		}

		public function transform(d : IPositionable) : Array
		{
			throw new IllegalOperationError( "draw() not implemented in" + this );
		}

		public function randomize() : void
		{
			throw new IllegalOperationError( "randomize() not implemented in" + this );
		}
	}
}
