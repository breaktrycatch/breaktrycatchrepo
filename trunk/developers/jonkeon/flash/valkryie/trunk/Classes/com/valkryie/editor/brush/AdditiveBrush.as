package com.valkryie.editor.brush {

	/**
	 * @author jkeon
	 */
	public class AdditiveBrush extends AbstractBrush {
		public function AdditiveBrush() {
			super();
			
			__outlineColor = 0x000066;
			__outlineAlpha = 1;
			__fillColor = 0x000066;
			__fillAlpha = 0;
		}
	}
}