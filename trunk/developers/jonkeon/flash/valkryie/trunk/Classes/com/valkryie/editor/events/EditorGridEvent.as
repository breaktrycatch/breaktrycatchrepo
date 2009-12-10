package com.valkryie.editor.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorGridEvent extends Event {
		
		public static const GRID_TOGGLE:String = "editor_grid_toggle";
		
		private var __isOn:Boolean;
		
		public function EditorGridEvent(type : String, _isOn:Boolean, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__isOn = _isOn;
		}
		
		public function get isOn() : Boolean {
			return __isOn;
		}
	}
}
