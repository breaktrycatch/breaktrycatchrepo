package com.valkryie.data.vo {
	import flash.events.IEventDispatcher;

	/**
	 * @author jkeon
	 */
	public class GridVO extends SerializableVO {
		
		public static const GRID_LAYER_BOTTOM:int = 0;
		public static const GRID_LAYER_TOP:int = 1;
		
		public function GridVO(target : IEventDispatcher = null) {
			super(target);
			snap = true;
			layer = GRID_LAYER_BOTTOM;
			shown = true;
			spacingWidth = 32;
			spacingDepth = 32;
		}
		
		public function get snap() : Boolean {
			return get("snap");
		}
		
		public function set snap(_snap : Boolean) : void {
			set("snap", _snap);
		}
		
		public function get shown() : Boolean {
			return get("shown");
		}
		
		public function set shown(_shown : Boolean) : void {
			set("shown", _shown);
		}
		
		public function get layer(): int {
			return get("layer");
		}
		
		public function set layer(_layer:int): void {
			set("layer", _layer);
		}
		
		public function get spacingWidth() : int {
			return get("spacingWidth");
		}
		
		public function set spacingWidth(_spacingWidth : int) : void {
			if (_spacingWidth < 1) {
				_spacingWidth = 1;
			}
			set("spacingWidth", _spacingWidth);
		}
		
		public function get spacingDepth() : int {
			return get("spacingDepth");
		}
		
		public function set spacingDepth(_spacingDepth : int) : void {
			if (_spacingDepth < 1) {
				_spacingDepth = 1;
			}
			set("spacingDepth", _spacingDepth);
		}
	}
}
