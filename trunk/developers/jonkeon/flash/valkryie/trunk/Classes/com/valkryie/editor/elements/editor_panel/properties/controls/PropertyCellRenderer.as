package com.valkryie.editor.elements.editor_panel.properties.controls {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.controls.listClasses.CellRenderer;
	import com.valkryie.editor.elements.editor_panel.properties.vo.PropertyVO;

	/**
	 * @author jkeon
	 */
	public class PropertyCellRenderer extends CellRenderer {
		
		public var property_mc:Label;
		public var element_mc:PropertyElement;
		
		protected var __propertyVO:PropertyVO;
		
		public function PropertyCellRenderer() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			this.visible = false;
			property_mc.text = "";
		}

		override protected function setData(obj : Object) : void {
			__data = obj;
			__propertyVO = __data as PropertyVO;
			if( !enabled )
			{ 
				enabled = true;
				mouseEnabled = true;
			}
			property_mc.text = __propertyVO.propertyName;
			element_mc.propertyVO = __propertyVO;
			this.visible = true;
		}
		
		override public function clearData() : void {
			
			property_mc.text = "";
			element_mc.clean;
			__propertyVO = null;
			__data = null;
			__listData = null;
			mouseEnabled = false;
			enabled = false;
			
			this.visible = false;
		}
		
		
	}
}
