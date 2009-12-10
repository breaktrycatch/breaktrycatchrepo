package com.valkryie.modal {
	import com.fuelindustries.core.AssetProxy;

	/**
	 * @author jkeon
	 */
	public class BlankModal extends BaseModal {
		public function BlankModal() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}
	}
}
