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
			
			__dataVO["isoX"] = (__vertex0.isoX + __vertex1.isoX)/2;
			__dataVO["isoY"] = (__vertex0.isoY + __vertex1.isoY)/2;
			__dataVO["isoZ"] = (__vertex0.isoZ + __vertex1.isoZ)/2;
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
			__bindings.push(__dataVO.bind("isoX", this, affectVerticesX));
			__bindings.push(__dataVO.bind("isoY", this, affectVerticesY));
			__bindings.push(__dataVO.bind("isoZ", this, affectVerticesZ));
			
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
			__vertex0.updateScreenCoordinates();
			__vertex1.updateScreenCoordinates();
			//construct shape
			graphics.clear();
			graphics.lineStyle(3, 0xFFFF00);
			graphics.moveTo(0, 0);
			graphics.lineTo(__vertex1.transformedX - __vertex0.transformedX, __vertex1.transformedY - __vertex0.transformedY);
			this.x = __vertex0.transformedX;
			this.y = __vertex0.transformedY;
		}
		
		protected function affectVerticesX(_newValue:int, _oldValue:int):void {
			var delta:int = _newValue - _oldValue;
			__vertex0.isoX += delta;
			__vertex1.isoX += delta;
		}
		protected function affectVerticesY(_newValue:int, _oldValue:int):void {
			var delta:int = _newValue - _oldValue;
			__vertex0.isoY += delta;
			__vertex1.isoY += delta;
		}
		protected function affectVerticesZ(_newValue:int, _oldValue:int):void {
			var delta:int = _newValue - _oldValue;
			__vertex0.isoZ += delta;
			__vertex1.isoZ += delta;
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
	}
}
