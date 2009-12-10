package com.valkryie.editor.elements {
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.data.vo.AbstractDataVO;
	import com.valkryie.data.vo.GridVO;
	import com.valkryie.editor.elements.editor_panel.PropertiesPane;
	import com.valkryie.editor.elements.editor_panel.ToolsPane;
	import com.valkryie.editor.events.EditorActionEvent;
	import com.valkryie.editor.grid.GridTools;

	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class EditorPanel extends AssetProxy {
		
		
		public var toolsPane_mc:ToolsPane;
		public var propertiesPane_mc:PropertiesPane;
		
		public var gridTools_mc:GridTools;
		
		public var addButton_mc:SimpleButton;
		
		
		
		public function EditorPanel() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			addButton_mc.addEventListener(MouseEvent.CLICK, onAddBrushToWorld);
		}
		
		public function setGridData(_gridData:GridVO):void {
			gridTools_mc.gridData = _gridData;
		}

		
		public function updateProperties(_dataVO:AbstractDataVO):void {
			propertiesPane_mc.updateProperties(_dataVO);
		}
		
		protected function onAddBrushToWorld(e:MouseEvent):void {
			this.dispatchEvent(new EditorActionEvent(EditorActionEvent.CREATE_ADDITIVE_BRUSH));
		}
		
		public function set activeTool(_activeTool : String) : void {
			toolsPane_mc.activeTool = _activeTool;
		}
		
		public function set activeSubTool(_activeSubTool : String) : void {
			toolsPane_mc.activeSubTool = _activeSubTool;
		}
	}
}
