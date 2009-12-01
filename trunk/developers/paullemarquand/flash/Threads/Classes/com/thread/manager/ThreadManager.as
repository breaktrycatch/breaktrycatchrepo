package com.thread.manager 
{
	import com.thread.vo.IVisualComponent;

	import flash.display.BitmapData;

	/**
	 * @author Paul
	 */
	public class ThreadManager extends AbstractThreadManager implements IVisualComponent
	{
		public function ThreadManager(canvas : BitmapData) 
		{
			super(canvas, this);
		}
	}
}
