package com.valkryie.core {
	import net.hires.debug.Stats;

	import com.fuelindustries.AbstractMain;
	import com.fuelindustries.events.ViewEvent;
	import com.module_keyinput.core.InputManager;
	import com.valkryie.data.statics.UIStatics;
	import com.valkryie.manager.ui.ValkryieModalManager;
	import com.valkryie.manager.ui.ValkryieViewManager;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class FrameworkCore extends AbstractMain implements IFrameworkCore {
		
		protected var __viewManager:ValkryieViewManager;
		protected var __modalManager:ValkryieModalManager;
		
		public function FrameworkCore() {
			super();
		}
		
		public function get display():MovieClip {
			return this;
		}

		override protected function onAdded(e : Event) : void {
			super.onAdded(e);
			init();
		}
		
		
		
		protected function init():void {
			
			InputManager.getInstance().initialize(this.stage);
			
			__viewManager = new ValkryieViewManager();
			__viewManager.linkDisplay();
			__modalManager = new ValkryieModalManager();
			__modalManager.linkDisplay();
			
			addChild(__viewManager.display);
			addChild(__modalManager.display);
			
			
			var stats:Stats = new Stats();
			this.addChild(stats);
			stats.x = 760 - stats.width;
			
			this.addEventListener(ViewEvent.CHANGE, onViewDispatcher);
			
			
			onViewDispatcher(new ViewEvent(ViewEvent.CHANGE, UIStatics.MODAL_CREATE_LEVEL));
			//onViewDispatcher(new ViewEvent(ViewEvent.CHANGE, UIStatics.VIEW_PARTICLES));
		}
		
		protected function onViewDispatcher(e:ViewEvent):void {
			e.stopPropagation();
			dtrace("View Change " + e.section);
			if (UIStatics.isView(e.section)) {
				__viewManager.changeSection(e.section);	
			}
			else if (UIStatics.isModal(e.section)) {
				__modalManager.changeSection(e.section);	
			}
			else {
				throw new Error("ViewEvent requesting change for " + e.section + " but is is not part of a category");
			}
		}
	}
}
