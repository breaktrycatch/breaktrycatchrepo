package com.core 
{
	import com.thread.ThreadContainer;

	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author Paul
	 */
	public class ThreadMain extends MovieClip 
	{
		private var _threadContainer : ThreadContainer;

		public function ThreadMain()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_threadContainer = new ThreadContainer( stage.stageWidth, stage.stageHeight );
			addChild( _threadContainer );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onReset );
			
//			KulerSingletonProxy.getInstance( ).service.getRandom( 0, 5 );
//			KulerSingletonProxy.getInstance( ).getRandomColours();
			
		}

		private function onReset(event : KeyboardEvent) : void
		{
			if(event.keyCode == Keyboard.SPACE)
			{
				_threadContainer.reset( );
			}
			else if(event.keyCode == Keyboard.ENTER)
			{
				_threadContainer.takeSnapshot( );
			}
		}
	}
}
