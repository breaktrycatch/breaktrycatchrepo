package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.vo.IPositionable;

	/**
	 * @author Paul
	 */
	public class FourWayTransform extends MirrorXTransform implements IDrawTransform 
	{
		override public function transform(d : IPositionable) : Array
		{
			var list : Array = super.transform( d );
			list.push( new Line( d.prevX, -d.prevY + ThreadConstants.MANAGER_HEIGHT, d.x, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
			list.push( new Line( -d.prevX + ThreadConstants.MANAGER_WIDTH, -d.prevY + ThreadConstants.MANAGER_HEIGHT, -d.x + ThreadConstants.MANAGER_WIDTH, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
			
			return list;
		}

		override public function randomize() : void
		{
			// do nothing
		}
	}
}
