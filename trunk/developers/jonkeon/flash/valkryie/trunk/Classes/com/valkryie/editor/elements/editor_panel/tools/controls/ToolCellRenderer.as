package com.valkryie.editor.elements.editor_panel.tools.controls {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.controls.listClasses.SelectableCellRenderer;
	import com.valkryie.editor.elements.editor_panel.tools.vo.ToolVO;

	/**
	 * @author jkeon
	 */
	public class ToolCellRenderer extends SelectableCellRenderer {
		
		public var label_mc:Label;
		
		protected var __toolVO:ToolVO;
		
		public function ToolCellRenderer() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			this.visible = false;
			label_mc.text = "";
		}

		override protected function setData(obj : Object) : void {
			__data = obj;
			__toolVO = __data as ToolVO;
			if( !enabled )
			{ 
				enabled = true;
				mouseEnabled = true;
			}
			label_mc.text = __toolVO.identifierLetter;
			this.visible = true;
		}

		override public function clearData() : void {
			
			label_mc.text = "";
			
			__toolVO = null;
			__data = null;
			__listData = null;
			mouseEnabled = false;
			enabled = false;
			
			if( selected == true )
			{
				selected = false;
			}
			this.visible = false;
		}
	}
}
