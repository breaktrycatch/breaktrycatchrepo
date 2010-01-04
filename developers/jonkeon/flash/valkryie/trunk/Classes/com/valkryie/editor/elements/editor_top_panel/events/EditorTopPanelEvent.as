package com.valkryie.editor.elements.editor_top_panel.events {
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorTopPanelEvent extends Event {
		
		public static const EDITOR_TOP_PANEL_NEW:String = "editor_top_panel_new";
		public static const EDITOR_TOP_PANEL_OPEN:String = "editor_top_panel_open";
		public static const EDITOR_TOP_PANEL_SAVE:String = "editor_top_panel_save";
		
		public static const EDITOR_TOP_PANEL_BRUSH_VISIBILITY:String = "editor_top_panel_brush_visibility";
		public static const EDITOR_TOP_PANEL_ACTOR_VISIBILITY:String = "editor_top_panel_actor_visibility";
		public static const EDITOR_TOP_PANEL_VERTEX_VISIBILITY:String = "editor_top_panel_vertex_visibility";
		public static const EDITOR_TOP_PANEL_EDGE_VISIBILITY:String = "editor_top_panel_edge_visibility";
		public static const EDITOR_TOP_PANEL_FACE_VISIBILITY:String = "editor_top_panel_face_visibility";
		
		protected var __value:Boolean;
		
		public function EditorTopPanelEvent(type : String, _value:Boolean = false, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__value = _value;
		}
		
		public function get _value() : Boolean {
			return __value;
		}
	}
}
