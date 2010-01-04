package com.valkryie.actor {
	import com.fuelindustries.core.AssetProxy;
	import com.module_data.Binding;
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.core.AbstractDataVO;

	import flash.events.Event;
	import flash.events.MouseEvent;
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
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onAdded(e:Event):void {
			addEventListener(MouseEvent.MOUSE_OVER, onMOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		}
		
		protected function onRemoved(e:Event):void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		}
		
		protected function setupData():void {
			__dataVO = new AbstractDataVO();	
		}
		
		protected function setupBindings():void {
			__bindings = [];
		}
		
		public function render():void {
			//OVERRIDE
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
	
		//INTERACTION HANDLERS
		protected function onMOver(e:MouseEvent):void {
			
		}
		
		protected function onMOut(e:MouseEvent):void {
			
		}
		
		protected function onMDown(e:MouseEvent):void {
			Subscriber.issue(new ActorEvent(ActorEvent.ACTOR_SELECTED, this));
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
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			removeEventListener(MouseEvent.MOUSE_OVER, onMOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			
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
