package com.thread.ai 
{
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;
	import com.thread.vo.IMotionable;

	/**
	 * @author Paul
	 */
	public class SimpleAgent extends AbstractAgent implements IAgent 
	{
		
		public function SimpleAgent(target : IMotionable)
		{
			super( target, this );
		}

		override public function update() : void
		{
		}

		override public function randomize() : void
		{
		}
	}
}
