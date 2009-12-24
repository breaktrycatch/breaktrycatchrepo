package com.valkryie.editor.statics {
	import com.valkryie.editor.elements.editor_panel.tools.vo.ToolVO;

	import flash.utils.Dictionary;

	/**
	 * @author jkeon
	 */
	public class ToolStatics extends Object {
		
		public static const TOOL_NONE:String = "editor_tool_none";
		
		public static const TOOL_SELECT_FACES:String = "editor_tool_select_faces";
		public static const TOOL_SELECT_EDGES:String = "editor_tool_select_edges";
		public static const TOOL_SELECT_VERTICES:String = "editor_tool_select_vertices";
		
		public static const TOOL_MOVE:String = "editor_tool_move";
		public static const TOOL_SCALE:String = "editor_tool_scale";
		public static const TOOL_ROTATE:String = "editor_tool_rotate";
		
		protected static var __toolsDictionary:Dictionary = new Dictionary(true);
		
		public function ToolStatics() {
		
		}
		
		public static function addTool(_identifier:String, _toolVO:ToolVO):void {
			__toolsDictionary[_identifier] = _toolVO;
		}
		
		public static function getTool(_identifier:String):ToolVO {
			return (__toolsDictionary[_identifier]);
		}
	}
}
