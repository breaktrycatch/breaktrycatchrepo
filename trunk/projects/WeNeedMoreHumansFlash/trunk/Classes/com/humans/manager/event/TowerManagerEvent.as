package com.humans.manager.event {
	import flash.display.Bitmap;
	import flash.events.Event;

	/**
	 * @author fuel
	 */
	public class TowerManagerEvent extends Event {
		public static const TOWER_READY:String = "TowerManagerEvent_TowerReady";
		public static const MANAGER_READY:String = "TowerManagerEvent_ManagerReady";
		
		private var _tower:Bitmap;
		public function get tower() : Bitmap {
			return _tower;
		}
		
		
		public function TowerManagerEvent(type : String, tower:Bitmap = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			_tower = tower;
		}
		
		
	}
}
