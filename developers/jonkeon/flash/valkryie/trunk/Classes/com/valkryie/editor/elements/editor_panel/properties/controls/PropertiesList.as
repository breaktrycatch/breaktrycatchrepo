package com.valkryie.editor.elements.editor_panel.properties.controls {
	import com.fuelindustries.controls.ScrollableList;

	/**
	 * @author jkeon
	 */
	public class PropertiesList extends ScrollableList {
		public function PropertiesList(cellRenderer : Class = null) {
			super(PropertyCellRenderer);
		}
	}
}
