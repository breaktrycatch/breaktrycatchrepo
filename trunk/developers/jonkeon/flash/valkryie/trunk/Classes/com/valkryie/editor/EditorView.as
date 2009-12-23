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
			
			__activeTool = ToolStatics.TOOL_SELECT_BRUSHES;
			__activeSubTool = ToolStatics.TOOL_MOVE;
			editorPanel.activeTool = __activeTool;
			editorPanel.activeSubTool = __activeSubTool;
			editorEnvironment.activeTool = __activeTool;
			editorEnvironment.activeSubTool = __activeSubTool;
			
			editorPanel.addEventListener(EditorToolSelectEvent.TOOL_CHANGE, onToolChange);
			editorPanel.addEventListener(EditorActionEvent.CREATE_ADDITIVE_BRUSH, onCreateAdditiveBrush);
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
		
		
		protected function onToolChange(e:EditorToolSelectEvent):void {
			dtrace("TOOL Change " + e.tool, e.subTool);
			if (__activeTool != e.tool) {
				__activeTool = e.tool;
				editorEnvironment.activeTool = __activeTool;
			}
			if (__activeSubTool != e.subTool) {
				__activeSubTool = e.subTool;
				editorEnvironment.activeSubTool = __activeSubTool;
			}
		}
		
		protected function onCreateAdditiveBrush(e:EditorActionEvent):void {
			editorEnvironment.createAdditiveBrush();
		}
		
		protected function onActorSelected(e:ActorEvent):void {
			//dtrace("Actor was selected " + e.actor);
			__selectedActor = e.actor;
			if (__selectedActor != null) {
				editorPanel.updateProperties(__selectedActor);
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
