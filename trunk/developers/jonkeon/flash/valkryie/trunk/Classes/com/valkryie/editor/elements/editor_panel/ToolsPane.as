package com.valkryie.editor.elements.editor_panel {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.ListEvent;
	import com.valkryie.editor.elements.editor_panel.tools.controls.ToolsList;
	import com.valkryie.editor.elements.editor_panel.tools.vo.ToolVO;
	import com.valkryie.editor.events.EditorToolSelectEvent;
	import com.valkryie.editor.statics.ToolStatics;

	/**
	 * @author jkeon
	 */
	public class ToolsPane extends FuelUI {
		
		public var title_mc:Label;
		public var subTitle_mc:Label;
		public var toolsList_mc:ToolsList;
		public var subToolsList_mc:ToolsList;
		
		protected var __toolsArray:Array;
		
		public function ToolsPane() {
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			
			toolsList_mc.addEventListener(ListEvent.ITEM_CLICK, onToolSelected);
			subToolsList_mc.addEventListener(ListEvent.ITEM_CLICK, onSubToolSelected);
			
			__toolsArray = [];
			
			//Creates Tools
			
			//MAIN TOOLS
			
			var brushSelectTool:ToolVO = new ToolVO();
			brushSelectTool.identifierLetter = "B";
			brushSelectTool.toolStatic = ToolStatics.TOOL_SELECT_BRUSHES;
			__toolsArray.push(brushSelectTool);
			
			var geoSelectTool:ToolVO = new ToolVO();
			geoSelectTool.identifierLetter = "G";
			geoSelectTool.toolStatic = ToolStatics.TOOL_SELECT_GEOMETRIC;
			__toolsArray.push(geoSelectTool);
			
			
			//SUB TOOLS
			var moveTool:ToolVO = new ToolVO();
			moveTool.identifierLetter = "M";
			moveTool.toolStatic = ToolStatics.TOOL_MOVE;
			brushSelectTool.childrenTools.push(moveTool);
			geoSelectTool.childrenTools.push(moveTool);
			
			var scaleTool:ToolVO = new ToolVO();
			scaleTool.identifierLetter = "S";
			scaleTool.toolStatic = ToolStatics.TOOL_SCALE;
			brushSelectTool.childrenTools.push(scaleTool);
			geoSelectTool.childrenTools.push(scaleTool);
			
			
			
			var facesTool:ToolVO = new ToolVO();
			facesTool.identifierLetter = "F";
			facesTool.toolStatic = ToolStatics.TOOL_SELECT_FACES;
			geoSelectTool.childrenTools.push(facesTool);
			
			var edgeTool:ToolVO = new ToolVO();
			edgeTool.identifierLetter = "E";
			edgeTool.toolStatic = ToolStatics.TOOL_SELECT_EDGES;
			geoSelectTool.childrenTools.push(edgeTool);
			
			var vertexTool:ToolVO = new ToolVO();
			vertexTool.identifierLetter = "V";
			vertexTool.toolStatic = ToolStatics.TOOL_SELECT_VERTICES;
			geoSelectTool.childrenTools.push(vertexTool);
			
			
			
			//Set the DataProvider
			toolsList_mc.dataProvider = __toolsArray;
			toolsList_mc.selectedIndex = 0;
			
			subTitle_mc.visible = false;
			
		}
		
		//When a tool is selected
		protected function onToolSelected(e:ListEvent):void {
			var toolVO:ToolVO = e.item as ToolVO;
			subToolsList_mc.dataProvider = toolVO.childrenTools;
			if (toolVO.childrenTools.length > 0) {
				subTitle_mc.visible = true;
				subToolsList_mc.selectedIndex = 0;
			}
			else {
				subTitle_mc.visible = false;
			}
			this.dispatchEvent(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_SELECTED, toolVO.toolStatic));
		}
		
		//When a sub tool is selected
		protected function onSubToolSelected(e:ListEvent):void {
			var toolVO:ToolVO = e.item as ToolVO;
			dtrace("Is this firing?");
			this.dispatchEvent(new EditorToolSelectEvent(EditorToolSelectEvent.SUB_TOOL_SELECTED, toolVO.toolStatic));
		}
	}
}
