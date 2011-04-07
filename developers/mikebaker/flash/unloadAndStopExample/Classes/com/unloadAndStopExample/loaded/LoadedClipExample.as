package com.unloadAndStopExample.loaded {
	import flash.utils.getQualifiedClassName;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Mike
	 */
	public class LoadedClipExample extends MovieClip 
	{
		public var now_txt:TextField;
		
		private var __framesPassed:int = 0;
		
		public function LoadedClipExample()
		{
			super();
			trace(getQualifiedClassName(this));
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.addEventListener(Event.ENTER_FRAME, onUpdate);
			onUpdate(null);
		}

		private function onUpdate(e : Event) : void 
		{
			__framesPassed++;
			now_txt.text = String(__framesPassed);
		}
	}
}
