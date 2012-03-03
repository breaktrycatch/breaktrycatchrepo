package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IPositionable;

	/**
	 * @author Paul
	 */
	public class MirrorYTransform extends SimpleTransform implements IDrawTransform 
	{
		override public function transform(d : IPositionable) : Array
		{
			var lines : Array = super.transform( d );
			lines.push( new Line( d.prevX, -d.prevY + ThreadConstants.MANAGER_HEIGHT, d.x, -d.y + ThreadConstants.MANAGER_HEIGHT ) );
			
			return lines;
		}
	}
}
