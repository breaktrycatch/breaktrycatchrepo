package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.vo.IPositionable;

	/**
	 * @author Paul
	 */
	public class SimpleTransform extends AbstractTransform implements IDrawTransform 
	{
		public function SimpleTransform() 
		{
			super();
		}

		override public function transform(d : IPositionable) : Array
		{
			var lines : Array = [];
			lines.push( new Line( d.prevX, d.prevY, d.x, d.y ) );
			return lines;
		}
		override public function randomize() : void		{
			// do nothing		}
	}
}
