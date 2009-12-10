package com.valkryie.editor.elements.editor_panel.tools.controls {
	import com.fuelindustries.controls.SelectableList;

	/**
	 * @author jkeon
	 */
	public class ToolsList extends SelectableList {
		public function ToolsList() {
			super();
			__cellRendererType = ToolCellRenderer;
		}
	}
}
