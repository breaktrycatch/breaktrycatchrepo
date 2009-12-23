package com.valkryie.editor.brush {
	import flash.geom.ColorTransform;

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

		override protected function setupColorTransforms() : void {
			__overColorTransform = new ColorTransform();
			__overColorTransform.color = 0xFF6666;
			
			__selectedColorTransform = new ColorTransform();
			__selectedColorTransform.color = 0xAA0000;
			
			__normalColorTransform = this.transform.colorTransform;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__stringName = "BUILDER BRUSH";
			
			__dataVO["isoX"] = 0;
			__dataVO["isoY"] = 0;
			__dataVO["isoDepth"] = 256;
			__dataVO["isoWidth"] = 256;
			__dataVO["subDivisionsX"] = 1;
			__dataVO["subDivisionsY"] = 1;
		}
	}
}
