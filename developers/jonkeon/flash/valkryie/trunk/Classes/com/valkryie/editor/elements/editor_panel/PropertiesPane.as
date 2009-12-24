package com.valkryie.editor.elements.editor_panel {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.core.FuelUI;
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.editor.elements.editor_panel.properties.controls.PropertiesList;

	/**
	 * @author jkeon
	 */
	public class PropertiesPane extends FuelUI {
		
		public var propertyList_mc:PropertiesList;
		public var title_mc:Label;
		public var selected_mc:Label;
		
		
		public function PropertiesPane() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			selected_mc.text = "NO ACTOR SELECTED";
			
		}
		
		public function updateProperties(_actor:AbstractActor):void {
			if (_actor == null) {
				propertyList_mc.dataProvider = null;
				selected_mc.text = "NO ACTOR SELECTED";
			}
			else {
				propertyList_mc.dataProvider = _actor.dataVO.properties;
				selected_mc.text = _actor.stringName;
			}
		}

		override public function destroy() : void {
			
			super.destroy();
		}
	}
}
