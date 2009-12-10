package com.valkryie.editor.brush.events {
	import com.valkryie.editor.brush.AbstractBrush;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class BrushEvent extends Event {
		
		public static const BRUSH_BEGIN_DRAG:String = "brush_begin_drag";
		public static const BRUSH_STOP_DRAG:String = "brush_stop_drag";
		
		
		private var __brush:AbstractBrush;
		
		public function BrushEvent(type : String, _brush:AbstractBrush, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__brush = _brush;
		}
		
		public function get brush() : AbstractBrush {
			return __brush;
		}
	}
}
