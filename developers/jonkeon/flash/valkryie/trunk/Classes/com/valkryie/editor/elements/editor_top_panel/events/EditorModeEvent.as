package com.valkryie.editor.elements.editor_top_panel.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorModeEvent extends Event {
		
		public static const EDITOR_MODE_CHANGE:String = "editor_mode_change";
		
		protected var __mode:String;
		
		public function EditorModeEvent(type : String, _mode:String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__mode = _mode;
		}
		
		public function get mode():String {
			return __mode;
		}
	}
}
