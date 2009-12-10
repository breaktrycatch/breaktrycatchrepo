package com.valkryie.editor {
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.GridVO;
	import com.valkryie.data.vo.LevelVO;
	import com.valkryie.editor.elements.EditorPanel;
	import com.valkryie.editor.environment.EditorEnvironment;
	import com.valkryie.editor.events.EditorActionEvent;
	import com.valkryie.editor.events.EditorToolSelectEvent;
	import com.valkryie.editor.statics.ToolStatics;
	import com.valkryie.manager.game.GameStateManager;
	import com.valkryie.view.BaseView;

	/**
	 * @author jkeon
	 */
	public class EditorView extends BaseView {
		
		//The custom rendering Environment
		public var editorEnvironment:EditorEnvironment;
		//The UI Panel
		public var editorPanel:EditorPanel;
		
		
		protected var __activeTool:String;
		protected var __activeSubTool:String;
		protected var __selectedActor:AbstractActor;
		
		public function EditorView() {
			super();
			linkage = "View_Editor";
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__activeTool = ToolStatics.TOOL_DRAW_PLANE;
			__activeSubTool = ToolStatics.TOOL_NONE;
			editorEnvironment.activeTool = __activeTool;
			
			editorPanel.addEventListener(EditorToolSelectEvent.TOOL_SELECTED, onToolSelected);
			editorPanel.addEventListener(EditorToolSelectEvent.SUB_TOOL_SELECTED, onSubToolSelected);
			editorPanel.addEventListener(EditorActionEvent.ADD_BRUSH, onAddBrush);
			editorEnvironment.addEventListener(ActorEvent.ACTOR_SELECTED, onActorSelected);
		}

		override protected function onAdded() : void {
			super.onAdded();
			init();
		}
		
		protected function init():void {
			
			var levelVO:LevelVO = GameStateManager.getInstance().activeLevelVO;
			
			if (levelVO != null) {
				var gridVO:GridVO = new GridVO();
				editorEnvironment.applyLevelData(levelVO);
				editorEnvironment.setGridData(gridVO);
				editorPanel.setGridData(gridVO);
				editorEnvironment.renderGeometry();
			}
			else {
				throw new Error("[EDITOR VIEW::init] - LevelVO is null!");
			}
			
			
		}
		
		
		protected function onToolSelected(e:EditorToolSelectEvent):void {
			__activeTool = e.tool;
			editorEnvironment.activeTool = __activeTool;
		}
		
		protected function onSubToolSelected(e:EditorToolSelectEvent):void {
			__activeSubTool = e.tool;
			editorEnvironment.activeSubTool = __activeSubTool;
		}
		
		protected function onAddBrush(e:EditorActionEvent):void {
			editorEnvironment.addActiveBrush();
		}
		
		protected function onActorSelected(e:ActorEvent):void {
			dtrace("Actor was selected " + e.actor);
			__selectedActor = e.actor;
			if (__selectedActor != null) {
				editorPanel.updateProperties(__selectedActor.dataVO);
			}
			else {
				editorPanel.updateProperties(null);
			}
		}
		
		override public function destroy() : void {
			
			
			
			super.destroy();
		}
	}
}
