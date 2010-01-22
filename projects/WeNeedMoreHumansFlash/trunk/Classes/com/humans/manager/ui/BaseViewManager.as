package com.humans.manager.ui {
	import com.fuelindustries.events.ViewEvent;
	import com.fuelindustries.view.AbstractViewManager;

	/**
	 * @author jkeon
	 */
	public class BaseViewManager extends AbstractViewManager {
		public function BaseViewManager() {
			super();
		}

		
		override protected function onSectionChange(event : ViewEvent) : void {
			throw new Error("CBaseViewManager::onSectionChange - Trying to change section to " + event.section + "\nYou should never get here. Don't dispatch the viewevent vis dispatchEvent, instead use Subscriber.issue");
		}
	}
}
