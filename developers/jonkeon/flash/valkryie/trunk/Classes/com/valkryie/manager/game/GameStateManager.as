package com.valkryie.manager.game {
	import com.valkryie.data.vo.LevelVO;

	/**
	 * @author jkeon
	 */
	public class GameStateManager extends Object {
		
		//Holds an instance of itself
		private static var __instance:GameStateManager;
		
		
		//The Active Level VO
		protected var __activeLevelVO:LevelVO;
		
		
		public function GameStateManager() {
			if (__instance == null) {
				super();
			}
			else {
				throw (new Error("[GAME STATE MANAGER::Constructor] - Can't Instantiate More than Once"));
			}
		}
		
		/**
		 * Gets the static instance of the Game State Manager
		 * 
		 * @return Instance of the Game State Manager
		 */
		public static function getInstance():GameStateManager {
			if (__instance == null) {
				__instance = new GameStateManager();
			}
			
			return __instance;
		}
		
		public function get activeLevelVO() : LevelVO {
			return __activeLevelVO;
		}
		
		public function set activeLevelVO(_activeLevelVO : LevelVO) : void {
			__activeLevelVO = _activeLevelVO;
		}
	}
}
