package com.thread.transform 
{
	import com.geom.Line;
	import com.thread.constant.ThreadConstants;
	import com.thread.motion.IPositionable;

	/**
	 * @author Paul
	 */
	public class FourWayIntermittentDrawer extends AbstractTransform implements IDrawTransform 
	{
		protected var _drawProbability : Number = .95;

		public function FourWayIntermittentDrawer()
		{
			super( this );
		}

		override public function transform(d : IPositionable) : Vector.<Line>
		{
			var lines : Vector.<Line> = new Vector.<Line>( );
			
			if(Math.random( ) > _drawProbability)
			{
				lines.push( new Line( d.prevX, d.prevY, d.x, d.y ) );
				
				//drawTarget.graphics.moveTo( d.prevX, d.prevY );
				//drawTarget.graphics.lineTo( d.x, d.y ) ;
			}
			if(Math.random( ) > _drawProbability)
			{
				lines.push( new Line( -d.prevX + ThreadConstants.MANAGER_WIDTH, d.prevY, -d.x + ThreadConstants.MANAGER_HEIGHT, d.y ) );
				
				//drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), d.prevY );
				//drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_HEIGHT ), d.y );
			}
			if(Math.random( ) > _drawProbability)
			{
				lines.push( new Line( d.prevX, -d.prevY + ThreadConstants.MANAGER_HEIGHT, d.x, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
				
				//drawTarget.graphics.moveTo( d.prevX, (-d.prevY + ThreadConstants.MANAGER_HEIGHT) );
				//drawTarget.graphics.lineTo( d.x, -d.y + ThreadConstants .MANAGER_HEIGHT );
			}
			if(Math.random( ) > _drawProbability)
			{
				lines.push( new Line( -d.prevX + ThreadConstants.MANAGER_WIDTH, -d.prevY + ThreadConstants.MANAGER_HEIGHT, -d.x + ThreadConstants.MANAGER_WIDTH, -d.y + ThreadConstants .MANAGER_HEIGHT ) );
				//drawTarget.graphics.moveTo( ( -d.prevX + ThreadConstants.MANAGER_WIDTH ), (-d.prevY + ThreadConstants.MANAGER_HEIGHT ) );
				//drawTarget.graphics.lineTo( ( -d.x + ThreadConstants.MANAGER_WIDTH ), -d.y + ThreadConstants .MANAGER_HEIGHT );
			}
			return lines;
		}

		public function get drawProbability() : Number
		{
			return _drawProbability;	
		}

		public function set drawProbability(n : Number) : void
		{
			_drawProbability = n;
		}
	}
}
