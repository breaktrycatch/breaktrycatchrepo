package com.thread.manager 
{
	import com.thread.motion.IComponent;
	
	import flash.display.BitmapData;	

	/**
	 * @author Paul
	 */
	public class ThreadManager extends AbstractThreadManager implements IComponent
	{
		public function ThreadManager(canvas : BitmapData) 
		{
			super(canvas, this);
			
		}
	}
}
