package com.thread.ai 
{
	import com.thread.motion.IMotionable;	
	import com.util.Randomizer;	
	import com.thread.ai.AbstractAgent;
	import com.thread.ai.IAgent;

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
	}
}
