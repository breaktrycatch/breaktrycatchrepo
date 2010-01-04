package com.valkryie.actor.geometric {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.StaticActor;
	import com.valkryie.data.vo.geometric.VertexVO;

	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 * @author Jon
	 */
	public class VertexActor extends StaticActor {
		
		
		protected var __overColorTransform:ColorTransform;
		protected var __normalColorTransform:ColorTransform;
		protected var __selectedColorTransform:ColorTransform;
		
		public function VertexActor() {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			super();
		}
		
		protected override function init():void {
			super.init();
			__stringName = "VERTEX " + __id;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			//construct shape
			graphics.beginFill(0xFFFF00);
			graphics.drawCircle(0, 0, 4);
			graphics.endFill();
			
			setupColorTransforms();
			
			this.useHandCursor = true;
			this.buttonMode = true;
		}
		


		override protected function setupData() : void {
			__dataVO = new VertexVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
			//Defaults
			__dataVO["isoX"] = 0;
			__dataVO["isoY"] = 0;
			__dataVO["isoZ"] = 0;
			__dataVO["u"] = 0;
			__dataVO["v"] = 0;
			
			__bindings.push(__dataVO.bind("isoX", this, reposition));
			__bindings.push(__dataVO.bind("isoY", this, reposition));
			__bindings.push(__dataVO.bind("isoZ", this, reposition));
		}
		
		
		
		
		protected function setupColorTransforms():void {
			__overColorTransform = new ColorTransform();
			__overColorTransform.color = 0xFF6666;
			
			__selectedColorTransform = new ColorTransform();
			__selectedColorTransform.color = 0xAA0000;
			
			__normalColorTransform = this.transform.colorTransform;
		}
		
		//INTERACTION HANDLERS
		
		protected override function onMOver(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __overColorTransform;
			}
		}
		protected override function onMOut(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __normalColorTransform;
			}
		}
		
		public override function set selected(_selected : Boolean) : void {
			if (__selected != _selected) {
				__selected = _selected;
				if (__selected) {
					this.transform.colorTransform = __selectedColorTransform;
				}
				else {
					this.transform.colorTransform = __normalColorTransform;
				}
			}
		}
		
		
		protected function reposition():void {
			(__dataVO as VertexVO).updateScreenCoordinates();
			
			x = __dataVO["transformedX"];
			y = __dataVO["transformedY"];
		}
		
		public function get isoX() : int {
			return __dataVO["isoX"];
		}
		
		public function set isoX(_isoX : int) : void {
			__dataVO["isoX"] = _isoX;
		}
		
		public function get isoY() : int {
			return __dataVO["isoY"];
		}
		
		public function set isoY(_isoY : int) : void {
			__dataVO["isoY"] = _isoY;
		}
		
		public function get isoZ() : int {
			return __dataVO["isoZ"];
		}
		
		public function set isoZ(_isoZ : int) : void {
			__dataVO["isoZ"] = _isoZ;
		}
		
		public function get u() : Number {
			return __dataVO["u"];
		}
		
		public function set u(_u : Number) : void {
			__dataVO["u"] = _u;
		}
		
		public function get v() : Number {
			return __dataVO["v"];
		}
		
		public function set v(_v : Number) : void {
			__dataVO["v"] = _v;
		}
	}
}
