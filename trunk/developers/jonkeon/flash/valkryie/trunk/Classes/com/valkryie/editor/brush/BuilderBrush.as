package com.valkryie.editor.brush {

	/**
	 * @author jkeon
	 */
	public class BuilderBrush extends AbstractBrush {
		public function BuilderBrush() {
			super();
			
			__outlineColor = 0x660000;
			__outlineAlpha = 1;
			__fillColor = 0x660000;
			__fillAlpha = 0.3;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__stringName = "Builder Brush";
			
			__dataVO["isoX"] = 0;
			__dataVO["isoY"] = 0;
			__dataVO["isoDepth"] = 256;
			__dataVO["isoWidth"] = 256;
		}
	}
}
