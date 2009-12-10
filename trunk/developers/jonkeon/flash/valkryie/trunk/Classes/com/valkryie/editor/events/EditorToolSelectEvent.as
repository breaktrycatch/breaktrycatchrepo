package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorToolSelectEvent extends Event {
		
		public static const TOOL_SELECTED:String = "editor_tool_selected";
		public static const SUB_TOOL_SELECTED:String = "editor_sub_tool_selected";
		
		private var __tool:String;
		
		public function EditorToolSelectEvent(type : String, _tool:String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__tool = _tool;
		}
		
		public function get tool():String {
			return __tool;
		}
	}
}
