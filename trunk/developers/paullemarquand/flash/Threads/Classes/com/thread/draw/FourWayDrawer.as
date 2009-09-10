package com.thread.draw 
{
	import com.thread.constant.ThreadConstants;
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class FourWayDrawer extends MirrorDrawer implements IDrawer 
	{
		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			super.draw( drawTarget, d );
			
			drawTarget.graphics.moveTo( d.prevX, (-d.prevY + ThreadConstants.MANAGER_HEIGHT) );
			drawTarget.graphics.lineTo( d.x, -d.y + ThreadConstants .MANAGER_HEIGHT );
					
			drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), (-d.prevY + ThreadConstants.MANAGER_HEIGHT ) );
			drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_WIDTH ), -d.y + ThreadConstants .MANAGER_HEIGHT );
		}
	}
}
