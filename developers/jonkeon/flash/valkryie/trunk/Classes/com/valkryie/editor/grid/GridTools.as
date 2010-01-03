package com.valkryie.editor.grid {
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.data.vo.editor.GridVO;

	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author jkeon
	 */
	public class GridTools extends AssetProxy {
		
		public var layerButton_mc:SimpleButton;
		public var snapButton_mc:SimpleButton;
		public var gridButton_mc:SimpleButton;
		public var depth_txt:TextField;
		public var width_txt:TextField;
		
		protected var __gridData:GridVO;
		
		public function GridTools() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			depth_txt.text = "";
			width_txt.text = "";
			layerButton_mc.toggle = true;
			snapButton_mc.toggle = true;
			gridButton_mc.toggle = true;
		}
		
		public function set gridData(_gridData:GridVO):void {
			__gridData = _gridData;
			
			layerButton_mc.addEventListener(MouseEvent.CLICK, onLayerToggle);
			snapButton_mc.addEventListener(MouseEvent.CLICK, onSnapToggle);
			gridButton_mc.addEventListener(MouseEvent.CLICK, onGridToggle);
			
			layerButton_mc.selected = (__gridData.layer == GridVO.GRID_LAYER_BOTTOM) ? false : true;
			snapButton_mc.selected = __gridData.snap;
			gridButton_mc.selected = __gridData.shown;
			
			depth_txt.text = String(__gridData.spacingDepth);
			width_txt.text = String(__gridData.spacingWidth);
			
			depth_txt.addEventListener(FocusEvent.FOCUS_OUT, onUpdateDepth);
			width_txt.addEventListener(FocusEvent.FOCUS_OUT, onUpdateWidth);
		}
		
		protected function onLayerToggle(e:MouseEvent):void {
			__gridData.layer = (layerButton_mc.selected) ? GridVO.GRID_LAYER_TOP : GridVO.GRID_LAYER_BOTTOM;
		}
		
		protected function onSnapToggle(e:MouseEvent):void {
			__gridData.snap = snapButton_mc.selected;
		}
		
		protected function onGridToggle(e:MouseEvent):void {
			__gridData.shown = gridButton_mc.selected;
		}
		
		protected function onUpdateDepth(e:FocusEvent):void {
			__gridData.spacingDepth = parseInt(depth_txt.text);
		}
		protected function onUpdateWidth(e:FocusEvent):void {
			__gridData.spacingWidth = parseInt(width_txt.text);
		}
		
		
	}
}
