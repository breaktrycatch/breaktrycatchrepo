package com.core
{

	import com.thread.constant.ThreadConstants;
	import flash.events.Event;
	import flash.display.StageAlign;
	import com.thread.ThreadContainer;
	import com.util.IntervalSave;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author Paul
	 */
	public class ThreadCore extends MovieClip
	{
		private var _threadContainer : ThreadContainer;
		private var _timedCapture : IntervalSave;

		public function ThreadCore()
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onReset );
			stage.addEventListener( Event.RESIZE, onResize );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function onResize(event : Event) : void
		{
			_threadContainer = new ThreadContainer( stage.stageWidth, stage.stageHeight );
			addChild( _threadContainer );
			
			if(ThreadConstants.CAPTURE_TIME > 0)
			{
			_timedCapture = new IntervalSave( _threadContainer, ThreadConstants.CAPTURE_TIME );
			_timedCapture.start();
			}
		}

		private function onReset(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				_threadContainer.reset();
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				_threadContainer.takeSnapshot();
			}
		}
	}
}
