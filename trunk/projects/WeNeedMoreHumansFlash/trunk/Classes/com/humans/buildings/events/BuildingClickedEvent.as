package com.humans.buildings.events {
	import com.humans.buildings.BuildingPlane;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class BuildingClickedEvent extends Event {
		
		public static const BUILDING_CLICKED:String = "building_clicked";
		
		protected var __building:BuildingPlane;
		
		public function BuildingClickedEvent(type : String, _building:BuildingPlane, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			__building = _building;
		}
		
		public function get building() : BuildingPlane {
			return __building;
		}
	}
}
