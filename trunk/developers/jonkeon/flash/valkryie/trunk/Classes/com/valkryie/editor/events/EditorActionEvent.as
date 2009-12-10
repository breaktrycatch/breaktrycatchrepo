package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorActionEvent extends Event {
		
		public static const ADD_BRUSH:String = "editor_add_brush";
		
		public function EditorActionEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
