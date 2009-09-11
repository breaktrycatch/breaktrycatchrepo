package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.motion.IPositionable;

	/**
	 * @author Paul
	 */
	public class SimpleTransform extends AbstractTransform implements IDrawTransform 
	{
		public function SimpleTransform() 
		{
			super( this );
		}

		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var lines : Vector.<Line> = new Vector.<Line>( );
			lines.push( new Line( d.prevX, d.prevY, d.x, d.y ) );
			return lines;
			/*
			drawTarget.graphics.moveTo( d.prevX, d.prevY );
			drawTarget.graphics.lineTo( d.x, d.y ) ;*/
		}
	}
}
