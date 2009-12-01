package com.thread.ai 
{	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;
	
	/**	 * @author plemarquand	 */	public class MandlebrotAgent extends AbstractAgent implements IAgent 
	{		public function MandlebrotAgent(target : IMotionable, enforcer : AbstractAgent)
		{			super( target, enforcer );		}
		
		override public function update() : void
		{
			var x0 : Number = _target.x;
			var y0 : Number = _target.y;
			var x : Number = 0;
			var y : Number = 0;
			var iteration : int = 0;
			var max_itr : int = 100;
			while(x*x + y*y <= (2*2) && iteration < max_itr)
			{
				var xtmp : Number = x*x - y*y + x0;
				y = 2*x*y + y0;
				x = xtmp;
				iteration = 1;
			}
			
			_target.angle += _target.angle - Math.atan2(y,x) / 1000;		}
		
		override public function randomize() : void
		{		}
	}}