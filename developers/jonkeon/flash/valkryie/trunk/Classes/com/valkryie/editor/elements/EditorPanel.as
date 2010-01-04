package com.valkryie.editor.elements {
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.AssetProxy;
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.editor.GridVO;
	import com.valkryie.editor.elements.editor_panel.PropertiesPane;
	import com.valkryie.editor.elements.editor_panel.ToolsPane;
	import com.valkryie.editor.events.EditorActionEvent;
	import com.valkryie.editor.grid.GridTools;

	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class EditorPanel extends AssetProxy {
		
		
		public var toolsPane_mc:ToolsPane;
		public var propertiesPane_mc:PropertiesPane;
		
		public var gridTools_mc:GridTools;
		
		public var addButton_mc:SimpleButton;
		
		
		
		public function EditorPanel() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			Subscriber.subscribe(ActorEvent.ACTOR_SELECTED, onActorSelected);
			addButton_mc.addEventListener(MouseEvent.CLICK, onAddBrushToWorld);
		}
		
		protected function onActorSelected(_event:ActorEvent):void {
			var actor:AbstractActor = _event.actor;
			propertiesPane_mc.updateProperties(actor);
			toolsPane_mc.updateTools(actor);
		}
		
		
		public function setGridData(_gridData:GridVO):void {
			gridTools_mc.gridData = _gridData;
		}
		
		protected function onAddBrushToWorld(e:MouseEvent):void {
			Subscriber.issue(new EditorActionEvent(EditorActionEvent.CREATE_ADDITIVE_BRUSH));
		}
		

		override public function destroy() : void {
			
			Subscriber.unsubscribe(ActorEvent.ACTOR_SELECTED, onActorSelected);
			super.destroy();
		}
	}
}
