package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.IPositionable;

	/**
	 * @author Paul
	 */
	public class FourWayTransform extends MirrorTransform implements IDrawTransform 
	{
		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var list : Vector.<Line> = super.transform( d );
			list.push( new Line( d.prevX, -d.prevY + ThreadConstants.MANAGER_HEIGHT, d.x, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
			list.push( new Line( -d.prevX + ThreadConstants.MANAGER_WIDTH, -d.prevY + ThreadConstants.MANAGER_HEIGHT, -d.x + ThreadConstants.MANAGER_WIDTH, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
			
			return list;
			/*
			drawTarget.graphics.moveTo( d.prevX, (-d.prevY + ThreadConstants.MANAGER_HEIGHT) );
			drawTarget.graphics.lineTo( d.x, -d.y + ThreadConstants .MANAGER_HEIGHT );
					
			drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), (-d.prevY + ThreadConstants.MANAGER_HEIGHT ) );
			drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_WIDTH ), -d.y + ThreadConstants .MANAGER_HEIGHT );
			 */
		}
	}
}
