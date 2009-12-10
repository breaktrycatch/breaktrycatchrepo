package com.valkryie.modal {
	import com.fuelindustries.view.AbstractView;

	/**
	 * @author jkeon
	 */
	public class BaseModal extends AbstractView {
		public function BaseModal() {
			super();
		}

		override public function playOut() : void {
			this.outComplete();
		}
	}
}
