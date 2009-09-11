package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.motion.IPositionable;

	import flash.errors.IllegalOperationError;

	/**
	 * @author Paul
	 */
	public class AbstractTransform implements IDrawTransform 
	{
		public function AbstractTransform(enforcer : AbstractTransform) 
		{
			
		}
		
		public function transform(d : IPositionable) : Vector.<Line>
		{
			throw new IllegalOperationError( "draw() not implemented in" + this );
		}
	}
}
