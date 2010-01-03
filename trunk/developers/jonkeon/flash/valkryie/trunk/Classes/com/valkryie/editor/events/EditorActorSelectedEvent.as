package com.valkryie.editor.events {
	import com.valkryie.data.vo.core.AbstractDataVO;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class EditorActorSelectedEvent extends Event {
		
		public static const ACTOR_SELECTED:String = "editor_object_selected";
		
		private var __dataVO:AbstractDataVO;
		
		public function EditorActorSelectedEvent(type : String, _dataVO:AbstractDataVO, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			__dataVO = _dataVO;
		}
		
		public function get propertiesVO() : AbstractDataVO {
			return __dataVO;
		}
	}
}
