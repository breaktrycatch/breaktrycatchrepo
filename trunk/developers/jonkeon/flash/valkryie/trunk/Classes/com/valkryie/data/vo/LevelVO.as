package com.valkryie.data.vo {

	/**
	 * @author jkeon
	 */
	public class LevelVO extends AbstractDataVO {
		
		public var cameraData:CameraVO;
		
		public function LevelVO() {
			super();
			
			levelIsoWidth = 1024;
			levelIsoDepth = 1024;
		}
		
		public function get levelIsoWidth() : int {
			return get("levelIsoWidth");
		}
		
		public function set levelIsoWidth(_levelIsoWidth : int) : void {
			if (_levelIsoWidth < 128) {
				_levelIsoWidth = 128;
			}
			set("levelIsoWidth", _levelIsoWidth);
		}
		
		public function get levelIsoDepth() : int {
			return get("levelIsoDepth");
		}
		
		public function set levelIsoDepth(_levelIsoDepth : int) : void {
			if (_levelIsoDepth < 128) {
				_levelIsoDepth = 128;
			}
			set("levelIsoDepth", _levelIsoDepth);
		}
		
		
	}
}
