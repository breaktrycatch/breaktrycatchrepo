package com.thread.draw 
{
	import com.thread.constant.ThreadConstants;
	import com.thread.draw.IDrawer;
	import com.thread.draw.SimpleDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;		

	/**
	 * @author Paul
	 */
	public class MirrorDrawer extends SimpleDrawer implements IDrawer 
	{

		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			super.draw( drawTarget, d );
			
			drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), d.prevY );
			drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_HEIGHT ), d.y );
		}
	}
}
