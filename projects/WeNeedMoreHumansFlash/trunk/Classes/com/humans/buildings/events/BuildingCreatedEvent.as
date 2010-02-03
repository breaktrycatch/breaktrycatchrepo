package com.humans.buildings.events {
	import com.humans.buildings.BuildingPlane;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class BuildingCreatedEvent extends Event {
		
		public static const BUILDING_CREATED:String = "building_created";
		
		protected var __building:BuildingPlane;
		
		public function BuildingCreatedEvent(type : String, _building:BuildingPlane, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__building = _building;
		}
		
		public function get building() : BuildingPlane {
			return __building;
		}
	}
}
