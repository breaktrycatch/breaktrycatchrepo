package com.valkryie.actor.geometric {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.StaticActor;
	import com.valkryie.data.vo.geometric.EdgeVO;
	import com.valkryie.data.vo.geometric.VertexVO;

	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 * @author Jon
	 */
	public class EdgeActor extends StaticActor {
		
		protected var __overColorTransform:ColorTransform;
		protected var __normalColorTransform:ColorTransform;
		protected var __selectedColorTransform:ColorTransform;
		
		protected var __vertex0:VertexVO;
		protected var __vertex1:VertexVO;
		
		public function EdgeActor(_vertex0:VertexVO, _vertex1:VertexVO) {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			__vertex0 = _vertex0;
			__vertex1 = _vertex1;
			super();
		}
		
		protected override function init():void {
			super.init();
			__stringName = "EDGE " + __id;
		}
		
		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			
			
			setupColorTransforms();
			
			this.useHandCursor = true;
			this.buttonMode = true;
		}
		
		override protected function setupData() : void {
			__dataVO = new EdgeVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
			__bindings.push(__vertex0.bind("isoX", this, render));
			__bindings.push(__vertex0.bind("isoY", this, render));
			__bindings.push(__vertex0.bind("isoZ", this, render));
			
			__bindings.push(__vertex1.bind("isoX", this, render));
			__bindings.push(__vertex1.bind("isoY", this, render));
			__bindings.push(__vertex1.bind("isoZ", this, render));
		}
		
		protected function setupColorTransforms():void {
			__overColorTransform = new ColorTransform();
			__overColorTransform.color = 0xFF6666;
			
			__selectedColorTransform = new ColorTransform();
			__selectedColorTransform.color = 0xAA0000;
			
			__normalColorTransform = this.transform.colorTransform;
		}

		override public function render() : void {
			//construct shape
			graphics.clear();
			graphics.lineStyle(3, 0xFFFF00);
			graphics.moveTo(0, 0);
			graphics.lineTo(__vertex1.transformedX - __vertex0.transformedX, __vertex1.transformedY - __vertex0.transformedY);
			this.x = __vertex0.transformedX;
			this.y = __vertex0.transformedY;
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
			__vertex0.updateScreenCoordinates();
			
			x = __vertex0["transformedX"];
			y = __vertex0["transformedY"];
		}
	}
}
