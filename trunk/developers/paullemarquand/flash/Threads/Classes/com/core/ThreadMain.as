package com.core 
{
	import com.adobe.kuler.KulerSingletonProxy;	
	import com.thread.ThreadContainer;
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;	

	/**
	 * @author Paul
	 */
	public class ThreadMain extends MovieClip 
	{
		public function ThreadMain()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var threadContainer : ThreadContainer = new ThreadContainer( stage.stageWidth, stage.stageHeight );
			addChild( threadContainer );
			
			KulerSingletonProxy.getInstance().service.getRandom(0, 50);
		}
	}
}
