package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorToolSelectEvent extends Event {
		
		public static const TOOL_CHANGE:String = "editor_tool_change";
		
		private var __tool:String;
		
		public function EditorToolSelectEvent(type : String, _tool:String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__tool = _tool;
		}
		
		public function get tool():String {
			return __tool;
		}
	
	}
}
