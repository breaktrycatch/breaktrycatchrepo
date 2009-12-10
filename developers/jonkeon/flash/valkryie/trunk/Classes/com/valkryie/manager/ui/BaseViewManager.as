package com.valkryie.manager.ui {
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.events.ViewEvent;
	import com.fuelindustries.view.AbstractViewManager;

	/**
	 * @author jkeon
	 */
	public class BaseViewManager extends AbstractViewManager {
		public function BaseViewManager() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}

		override protected function onSectionChange(event : ViewEvent) : void {
			//DO NOTHING AND LET FRAMEWORKCORE::ONVIEWDISPATCHER TAKE CARE OF IT
		}
	}
}
