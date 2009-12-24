package com.valkryie.editor.elements.editor_panel {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.ListEvent;
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.editor.brush.AbstractBrush;
	import com.valkryie.editor.elements.editor_panel.tools.controls.ToolsList;
	import com.valkryie.editor.elements.editor_panel.tools.vo.ToolVO;
	import com.valkryie.editor.events.EditorToolSelectEvent;
	import com.valkryie.editor.statics.ToolStatics;

	/**
	 * @author jkeon
	 */
	public class ToolsPane extends FuelUI {
		
		public var title_mc:Label;
		public var toolsList_mc:ToolsList;
		
		protected var __toolsArray:Array;
		
		protected var __activeTool:String;


		public function ToolsPane() {
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();

			//TOOLS
			
			//MOVE
			var moveTool:ToolVO = new ToolVO();
			moveTool.identifierLetter = "M";
			moveTool.toolStatic = ToolStatics.TOOL_MOVE;
			ToolStatics.addTool(ToolStatics.TOOL_MOVE, moveTool);
			//SCALE
			var scaleTool:ToolVO = new ToolVO();
			scaleTool.identifierLetter = "S";
			scaleTool.toolStatic = ToolStatics.TOOL_SCALE;
			ToolStatics.addTool(ToolStatics.TOOL_SCALE, scaleTool);
			
			//FACES
			var facesTool:ToolVO = new ToolVO();
			facesTool.identifierLetter = "F";
			facesTool.toolStatic = ToolStatics.TOOL_SELECT_FACES;
			ToolStatics.addTool(ToolStatics.TOOL_SELECT_FACES, facesTool);
			//EDGES
			var edgeTool:ToolVO = new ToolVO();
			edgeTool.identifierLetter = "E";
			edgeTool.toolStatic = ToolStatics.TOOL_SELECT_EDGES;
			ToolStatics.addTool(ToolStatics.TOOL_SELECT_EDGES, edgeTool);
			//VERTEX
			var vertexTool:ToolVO = new ToolVO();
			vertexTool.identifierLetter = "V";
			vertexTool.toolStatic = ToolStatics.TOOL_SELECT_VERTICES;
			ToolStatics.addTool(ToolStatics.TOOL_SELECT_VERTICES, vertexTool);
			
			
			
			//Set the DataProvider
			toolsList_mc.dataProvider = __toolsArray;
			
			toolsList_mc.addEventListener(ListEvent.ITEM_CLICK, onToolSelected);
		}
		
		public function updateTools(_actor:AbstractActor):void {
			//Based on the Object, Populate the tools.
			__toolsArray = [];
			if (_actor != null) {
				if (_actor is AbstractBrush) {
					__toolsArray.push(ToolStatics.getTool(ToolStatics.TOOL_MOVE));
					__toolsArray.push(ToolStatics.getTool(ToolStatics.TOOL_SCALE));
					__toolsArray.push(ToolStatics.getTool(ToolStatics.TOOL_SELECT_FACES));
					__toolsArray.push(ToolStatics.getTool(ToolStatics.TOOL_SELECT_EDGES));
					__toolsArray.push(ToolStatics.getTool(ToolStatics.TOOL_SELECT_VERTICES));
				}
			}
			
			toolsList_mc.dataProvider = __toolsArray;
			if (toolsList_mc.selectedItem != null) {
				Subscriber.issue(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_CHANGE, (toolsList_mc.selectedItem as ToolVO).toolStatic));
			}
			else {
				Subscriber.issue(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_CHANGE, ToolStatics.TOOL_NONE));
			}
		}
		
		protected function onToolSelected(e:ListEvent):void {
			Subscriber.issue(new EditorToolSelectEvent(EditorToolSelectEvent.TOOL_CHANGE, (e.item as ToolVO).toolStatic));
		}
	}
}
