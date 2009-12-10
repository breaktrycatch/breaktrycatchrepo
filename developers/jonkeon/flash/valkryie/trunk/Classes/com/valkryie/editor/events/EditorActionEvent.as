package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorActionEvent extends Event {
		
		public static const CREATE_ADDITIVE_BRUSH:String = "editor_create_additive_brush";
		
		public function EditorActionEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
