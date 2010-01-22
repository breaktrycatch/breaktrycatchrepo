package com.humans.ui.view {
	import com.fuelindustries.view.AbstractView;

	/**
	 * @author jkeon
	 */
	public class BaseView extends AbstractView {
		public function BaseView() {
			super();
		}

		override public function playOut() : void {
			this.outComplete();
		}
	}
}
