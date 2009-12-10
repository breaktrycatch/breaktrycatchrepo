package com.valkryie.editor.elements.editor_panel {
	import com.fuelindustries.core.FuelUI;
	import com.valkryie.data.vo.AbstractDataVO;
	import com.valkryie.editor.elements.editor_panel.properties.controls.PropertiesList;

	/**
	 * @author jkeon
	 */
	public class PropertiesPane extends FuelUI {
		
		public var propertyList_mc:PropertiesList;
		
		
		
		public function PropertiesPane() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
		}
		
		public function updateProperties(_dataVO:AbstractDataVO):void {
			propertyList_mc.dataProvider = _dataVO.properties;
		}
	}
}
