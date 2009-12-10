package com.valkryie.editor.elements.editor_panel.tools.vo {

	/**
	 * @author jkeon
	 */
	public class ToolVO extends Object {
		
		public var identifierLetter:String;
		public var toolStatic:String;
		public var subTool:Boolean;
		public var childrenTools:Array;
		
		public function ToolVO() {
			childrenTools = [];
		}
	}
}
