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
		
		protected var __activeTool:String;
		protected var __activeSubTool:String;
		
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
		
		public function set activeTool(_activeTool : String) : void {
			var toolVO:ToolVO;
			toolSearch: for (var b in toolsList_mc.dataProvider) {
				toolVO = toolsList_mc.dataProvider[b];
				if (toolVO.toolStatic == _activeTool) {
					if (toolsList_mc.selectedIndex != int(b)) {
						toolsList_mc.selectedIndex = int(b);
					}
					__activeTool = _activeTool;
					populateChildren(toolVO);
					break toolSearch;
				}
			}
		}
		
		public function set activeSubTool(_activeSubTool : String) : void {
			var toolVO:ToolVO;
			toolSearch: for (var b in subToolsList_mc.dataProvider) {
				toolVO = subToolsList_mc.dataProvider[b];
				if (toolVO.toolStatic == _activeSubTool) {
					if (subToolsList_mc.selectedIndex != int(b)) {
						subToolsList_mc.selectedIndex = int(b);
					}
					__activeSubTool = _activeSubTool;
					break toolSearch;
				}
			}
		}
		
		protected function populateChildren(_toolVO:ToolVO):void {
			subToolsList_mc.dataProvider = _toolVO.childrenTools;
			if (_toolVO.childrenTools.length > 0) {
				subTitle_mc.visible = true;
				subToolsList_mc.selectedIndex = 0;
				__activeSubTool = (subToolsList_mc.dataProvider[0] as ToolVO).toolStatic;
			}
			else {
				subTitle_mc.visible = false;
				__activeSubTool = ToolStatics.TOOL_NONE;
			}
		}
		
		//When a tool is selected
		protected function onToolSelected(e:ListEvent):void {
			var toolVO:ToolVO = e.item as ToolVO;
			__activeTool = toolVO.toolStatic;
			populateChildren(toolVO);
			this.dispatchEvent(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_CHANGE, __activeTool, __activeSubTool));
		}
		
		//When a sub tool is selected
		protected function onSubToolSelected(e:ListEvent):void {
			var toolVO:ToolVO = e.item as ToolVO;
			__activeSubTool = toolVO.toolStatic;
			this.dispatchEvent(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_CHANGE, __activeTool, __activeSubTool));
		}
	}
}
