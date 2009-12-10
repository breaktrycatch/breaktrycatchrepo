package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorToolSelectEvent extends Event {
		
		public static const TOOL_CHANGE:String = "editor_tool_change";
		
		private var __tool:String;
		private var __subTool:String;
		
		public function EditorToolSelectEvent(type : String, _tool:String, _subTool:String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__tool = _tool;
			__subTool = _subTool;
		}
		
		public function get tool():String {
			return __tool;
		}
		
		public function get subTool() : String {
			return __subTool;
		}
	}
}
