package com.valkryie.editor.elements {
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.AssetProxy;
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.editor.elements.editor_top_panel.events.EditorTopPanelEvent;

	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class EditorTopPanel extends AssetProxy {
		
		public var new_btn:SimpleButton;
		public var open_btn:SimpleButton;
		public var save_btn:SimpleButton;
		
		public var brushVisibility_btn:SimpleButton;
		public var actorVisibility_btn:SimpleButton;
		
		public function EditorTopPanel() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			brushVisibility_btn.toggle = true;
			brushVisibility_btn.selected = true;
			actorVisibility_btn.toggle = true;
			actorVisibility_btn.selected = true;
			
			new_btn.addEventListener(MouseEvent.CLICK, onNew);
			open_btn.addEventListener(MouseEvent.CLICK, onOpen);
			save_btn.addEventListener(MouseEvent.CLICK, onSave);
			
			brushVisibility_btn.addEventListener(MouseEvent.CLICK, onBrushVisibility);
			actorVisibility_btn.addEventListener(MouseEvent.CLICK, onActorVisibility);
		}
		
		protected function onNew(e:MouseEvent):void {
			Subscriber.issue(new EditorTopPanelEvent(EditorTopPanelEvent.EDITOR_TOP_PANEL_NEW));
		}
		protected function onOpen(e:MouseEvent):void {
			Subscriber.issue(new EditorTopPanelEvent(EditorTopPanelEvent.EDITOR_TOP_PANEL_OPEN));
		}
		protected function onSave(e:MouseEvent):void {
			Subscriber.issue(new EditorTopPanelEvent(EditorTopPanelEvent.EDITOR_TOP_PANEL_SAVE));
		}
		
		protected function onBrushVisibility(e:MouseEvent):void {
			Subscriber.issue(new EditorTopPanelEvent(EditorTopPanelEvent.EDITOR_TOP_PANEL_BRUSH_VISIBILITY, brushVisibility_btn.selected));
		}
		protected function onActorVisibility(e:MouseEvent):void {
			Subscriber.issue(new EditorTopPanelEvent(EditorTopPanelEvent.EDITOR_TOP_PANEL_ACTOR_VISIBILITY, actorVisibility_btn.selected));
		}

		override public function destroy() : void {
			
			new_btn.removeEventListener(MouseEvent.CLICK, onNew);
			new_btn.destroy();
			new_btn = null;
			open_btn.removeEventListener(MouseEvent.CLICK, onOpen);
			open_btn.destroy();
			open_btn = null;
			save_btn.removeEventListener(MouseEvent.CLICK, onSave);
			save_btn.destroy();
			save_btn = null;
			
			brushVisibility_btn.removeEventListener(MouseEvent.CLICK, onBrushVisibility);
			brushVisibility_btn.destroy();
			brushVisibility_btn = null;
			actorVisibility_btn.removeEventListener(MouseEvent.CLICK, onActorVisibility);
			actorVisibility_btn.destroy();
			actorVisibility_btn = null;
			
			super.destroy();
		}
	}
}
