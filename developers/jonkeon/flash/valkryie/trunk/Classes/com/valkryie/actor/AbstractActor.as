package com.valkryie.actor {
	import com.fuelindustries.core.AssetProxy;
	import com.module_data.Binding;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.AbstractDataVO;

	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class AbstractActor extends AssetProxy {
		
		protected var __dataVO:AbstractDataVO;	
		
		protected var __bounds:Rectangle;
		
		protected var __bindings:Array;
		
		protected var __activated:Boolean;
		protected var __selected:Boolean;
		
		
		protected var __overColorTransform:ColorTransform;
		protected var __normalColorTransform:ColorTransform;
		protected var __selectedColorTransform:ColorTransform;
		
		public function AbstractActor() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			setupColorTransforms();
			setupData();
			setupBindings();
			__bounds = new Rectangle();
		}
		
		protected function setupColorTransforms():void {
			__overColorTransform = new ColorTransform();
			__overColorTransform.color = 0xFF6666;
			
			__selectedColorTransform = new ColorTransform();
			__selectedColorTransform.color = 0xAA0000;
			
			__normalColorTransform = this.transform.colorTransform;
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
			
			__overColorTransform = null;
			__normalColorTransform = null;
			__selectedColorTransform = null;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMOut);
			
			
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
		
		public function get activated() : Boolean {
			return __activated;
		}
		
		public function set activated(_activated : Boolean) : void {
			__activated = _activated;
		}
		
		public function get selected() : Boolean {
			return __selected;
		}
		
		public function set selected(_selected : Boolean) : void {
			__selected = _selected;
			if (__selected) {
				this.transform.colorTransform = __selectedColorTransform;
			}
			else {
				this.transform.colorTransform = __normalColorTransform;
			}
		}
		
		
		//INTERACTION HANDLERS
		
		protected function onMDown(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
		}
		protected function onMUp(e:MouseEvent):void {
			e.stopImmediatePropagation();
			this.dispatchEvent(new ActorEvent(ActorEvent.ACTOR_SELECTED, this));
		}
		
		protected function onMOver(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __overColorTransform;
			}
		}
		protected function onMOut(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __normalColorTransform;
			}
		}
		
		
	}
}
