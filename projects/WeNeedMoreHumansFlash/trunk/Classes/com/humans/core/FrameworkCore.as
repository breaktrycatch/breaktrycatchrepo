package com.humans.core {
	import net.hires.debug.Stats;

	import com.fuelindustries.AbstractMain;
	import com.fuelindustries.events.ViewEvent;
	import com.humans.data.statics.AppStatics;
	import com.humans.data.statics.UIStatics;
	import com.humans.manager.ui.ModalManager;
	import com.humans.manager.ui.ViewManager;
	import com.module_keyinput.core.InputManager;
	import com.module_subscriber.core.Subscriber;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class FrameworkCore extends AbstractMain implements IFrameworkCore {
		
		protected var __viewManager:ViewManager;
		protected var __modalManager:ModalManager;
		
		
		//DEBUG SPECIFIC
		protected var __stats:Stats;
		
		
		public function FrameworkCore() {
			super();
		}

		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			init();
		}
		
		protected function init():void {
			
			InputManager.getInstance().initialize(this.stage);
			
			__viewManager = new ViewManager();
			__viewManager.linkDisplay();
			__modalManager = new ModalManager();
			__modalManager.linkDisplay();
			
			
			addChild(__viewManager.display);
			addChild(__modalManager.display);
			
			
			if (AppStatics.DEBUG_MODE) {
				debugHandleStats();
			}
			
			
			Subscriber.subscribe(ViewEvent.CHANGE, onViewDispatcher);
			
			onViewDispatcher(new ViewEvent(ViewEvent.CHANGE, UIStatics.VIEW_GALLERY));
		}
		
		protected function onViewDispatcher(e:ViewEvent):void {
			e.stopImmediatePropagation();
			dtrace("View Change " + e.section, e.initObject);
			if (UIStatics.isView(e.section)) {
				__viewManager.changeSection(e.section, e.initObject);
			}
			else if (UIStatics.isModal(e.section)) {
				__modalManager.changeSection(e.section, e.initObject);
			}
			else {
				throw new Error("ViewEvent requesting change for " + e.section + " but it is not part of a category. Refer to UIStatics.as"); 
			}
		}
		
		
		//DEBUG FUNCTIONS
		
		protected function debugHandleStats():void {
			__stats = new Stats();
			this.addChild(__stats);
			__stats.x = 760 - __stats.width;
			InputManager.getInstance().mapFunction(InputManager.KEY_F3, debugToggleStats);
		}
		
		protected function debugToggleStats():void {
			if (__stats.parent) {
				removeChild(__stats);
			}
			else {
				addChild(__stats);
			}
		}
		
		public function get display() : MovieClip {
			return this;
		}
	
	}
}
