package com.humans.buildings {
	import com.fuelindustries.core.AssetProxy;
	import com.humans.buildings.events.BuildingClickedEvent;
	import com.module_subscriber.core.Subscriber;

	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class BuildingMC extends AssetProxy {
		
		protected var __building:BuildingPlane;
		
		public function BuildingMC() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			this.addEventListener(MouseEvent.CLICK, onMClick);
		}
		
		protected function onMClick(e:MouseEvent):void {
			Subscriber.issue(new BuildingClickedEvent(BuildingClickedEvent.BUILDING_CLICKED, __building));
		}
		
		public function get building() : BuildingPlane {
			return __building;
		}
		
		public function set building(_building : BuildingPlane) : void {
			__building = _building;
		}
	}
}
