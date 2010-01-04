package com.valkryie.editor {
	import com.valkryie.data.vo.editor.GridVO;
	import com.valkryie.data.vo.level.LevelVO;
	import com.valkryie.editor.elements.EditorPanel;
	import com.valkryie.editor.elements.EditorTopPanel;
	import com.valkryie.editor.environment.EditorEnvironment;
	import com.valkryie.editor.events.EditorActionEvent;
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
		//The Top Panel
		public var topPanel:EditorTopPanel;
		
		
		
		public function EditorView() {
			super();
			linkage = "View_Editor";
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
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
		
		
		override public function destroy() : void {
			
			
			
			super.destroy();
		}
	}
}
