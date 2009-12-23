package com.valkryie.actor {
	import com.fuelindustries.core.AssetProxy;
	import com.module_data.Binding;
	import com.valkryie.data.vo.AbstractDataVO;

	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class AbstractActor extends AssetProxy {
		
		protected static var ACTOR_UID:int = 0;
		
		protected var __dataVO:AbstractDataVO;	
		
		protected var __bounds:Rectangle;
		
		protected var __bindings:Array;
		
		protected var __selected:Boolean;
		
		protected var __id:int;
		protected var __stringName:String;
		
		
		public function AbstractActor() {
			super();
			init();
		}
		
		protected function init():void {
			__id = ACTOR_UID;
			ACTOR_UID++;
			__stringName = "GENERIC ACTOR " + __id;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			setupData();
			setupBindings();
			__bounds = new Rectangle();
		}
		
		protected function setupData():void {
			__dataVO = new AbstractDataVO();	
		}
		
		protected function setupBindings():void {
			__bindings = [];
		}

		
		public function calculateBounds():void {
			__bounds.x = this.x - (this.width/2);
			__bounds.y = this.y - this.height;
			__bounds.width = this.width;
			__bounds.height = this.height;
		}
		
		public function get bounds() : Rectangle {
			if (__bounds != null) {
				return __bounds; 
			}
			else {
				throw new Error("Actor " + this + " does not have it's bounds set. Please call calculate Bounds first");
				return null;
			}
		}
	

		override public function destroy() : void {
			
			__bounds = null;
			
			
			
			
			
			
			var b:Binding;
			for (var i:int = 0; i<__bindings.length; i++) {
				b = __bindings[i] as Binding;
				b.unbind();
				__bindings[i] = null;
			}
			b = null;
			
			__dataVO = null;
			
			
			
			super.destroy();
		}
		
		public function get dataVO() : AbstractDataVO {
			return __dataVO;
		}
		
		public function set dataVO(_dataVO : AbstractDataVO) : void {
			__dataVO = _dataVO;
		}
		
		public function get selected() : Boolean {
			return __selected;
		}
		
		public function set selected(_selected : Boolean) : void {
			if (__selected != _selected) {
				__selected = _selected;
			}
		}
		
		public function get stringName() : String {
			return __stringName;
		}
		
		public function get id() : int {
			return __id;
		}
		
		
		
		
		
	}
}
