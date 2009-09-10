package com.thread.draw 
{
	import com.thread.constant.ThreadConstants;
	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;

	import flash.display.Sprite;	

	/**
	 * @author Paul
	 */
	public class FourWayIntermittentDrawer extends AbstractDrawer implements IDrawer 
	{
		protected var _drawProbability : Number = .95;
		
		public function FourWayIntermittentDrawer()
		{
			super( this );
		}

		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			if(Math.random( ) > _drawProbability)
			{
				drawTarget.graphics.moveTo( d.prevX, d.prevY );
				drawTarget.graphics.lineTo( d.x, d.y ) ;
			}
			if(Math.random( ) > _drawProbability)
			{
				
				drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), d.prevY );
				drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_HEIGHT ), d.y );
			}
			if(Math.random( ) > _drawProbability)
			{
				
				drawTarget.graphics.moveTo( d.prevX, (-d.prevY + ThreadConstants.MANAGER_HEIGHT) );
				drawTarget.graphics.lineTo( d.x, -d.y + ThreadConstants .MANAGER_HEIGHT );
			}
			if(Math.random( ) > _drawProbability)
			{
					
				drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), (-d.prevY + ThreadConstants.MANAGER_HEIGHT ) );
				drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_WIDTH ), -d.y + ThreadConstants .MANAGER_HEIGHT );
			}
		}
		
		public function get drawProbability():Number
		{
			return _drawProbability;	
		}
		
		public function set drawProbability(n : Number):void
		{
			_drawProbability = n;
		}
	}
}
