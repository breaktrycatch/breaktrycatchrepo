package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.IPositionable;

	/**
	 * @author Paul
	 */
	public class MirrorTransform extends SimpleTransform implements IDrawTransform 
	{
		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var lines : Vector.<Line> = super.transform( d );
			lines.push( new Line( -d.prevX + ThreadConstants.MANAGER_WIDTH, d.prevY, -d.x + ThreadConstants.MANAGER_HEIGHT, d.y ) );
			return lines;
		}
	}
}
