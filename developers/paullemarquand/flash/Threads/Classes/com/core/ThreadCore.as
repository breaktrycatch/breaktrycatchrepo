package com.core
{

	import com.thread.ThreadContainer;
	import com.thread.constant.ThreadConstants;
	import com.util.IntervalSave;
	import com.util.PromptUtil;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * @author Paul
	 */
	public class ThreadCore extends MovieClip
	{
		private var _threadContainer : ThreadContainer;
		private var _timedCapture : IntervalSave;
		private static var __stage : Stage;

		public function ThreadCore()
		{
			__stage = stage;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onReset );
			stage.addEventListener( Event.RESIZE, onResize );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function onResize(event : Event) : void
		{
			_threadContainer = new ThreadContainer( stage.stageWidth, stage.stageHeight );
			addChild( _threadContainer );

			if (ThreadConstants.CAPTURE_TIME > 0)
			{
				_timedCapture = new IntervalSave( _threadContainer, ThreadConstants.CAPTURE_TIME );
				_timedCapture.start();
			}
		}

		private function onReset(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				trace("ThreadCore.onReset(",[event],")");
				PromptUtil.confirm( this, _threadContainer.reset );
				
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				_threadContainer.takeSnapshot();
			}
			else if (event.keyCode == Keyboard.TAB)
			{
				_threadContainer.removeThread();
			}
			else if (event.keyCode == Keyboard.A)
			{
				_threadContainer.addThread();
			}
		}

		public static function get stage() : Stage
		{
			return __stage;
		}
	}
}
