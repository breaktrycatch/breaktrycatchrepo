package com.valkryie.view {
	import com.fuelindustries.core.AssetProxy;

	/**
	 * @author jkeon
	 */
	public class BlankView extends BaseView {
		public function BlankView() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}
	}
}
