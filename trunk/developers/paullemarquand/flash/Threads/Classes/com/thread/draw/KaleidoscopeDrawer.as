package com.thread.draw 
{
	import com.thread.draw.AbstractDrawer;
	import com.thread.draw.IDrawer;
	import com.thread.motion.IMotionable;
	
	import flash.display.Sprite;		

	/**
	 * @author Paul
	 */
	public class KaleidoscopeDrawer extends AbstractDrawer implements IDrawer 
	{

		private var _sections : int;	

		public function KaleidoscopeDrawer(sections : int = 20)
		{
			_sections = sections;
			super( this );
		}

		override public function draw(drawTarget : Sprite, d : IMotionable) : void
		{
			for (var i : Number = 0; i < _sections ; i++) 
			{
				var rot : Number = (Math.PI * 2) * (i / _sections);
				
//				var nX : Number = Math.cos( rot ) * d.x + ThreadConstants.MANAGER_WIDTH / 2;
//				var nY : Number = Math.sin( rot ) * d.y + ThreadConstants.MANAGER_HEIGHT / 2;
//				
//				var pX : Number = Math.cos( rot ) * d.prevX + ThreadConstants.MANAGER_WIDTH / 2;
//				var pY : Number = Math.sin( rot ) * d.prevY + ThreadConstants.MANAGER_HEIGHT / 2;
				
				var nX : Number = d.x;
				var nY : Number = d.y;
				
				var pX : Number = d.prevX;
				var pY : Number = d.prevY;
				
				drawTarget.graphics.moveTo( pX, pY );
				drawTarget.graphics.lineTo( nX, nY );
				
			}
		}
	}
}
