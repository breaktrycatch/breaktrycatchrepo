package com.valkryie.editor.brush {
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

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
		
		override protected function setupColorTransforms() : void {
			__overColorTransform = new ColorTransform();
			__overColorTransform.color = 0x0000FF;
			
			__selectedColorTransform = new ColorTransform();
			__selectedColorTransform.color = 0x0000AA;
			
			__normalColorTransform = this.transform.colorTransform;
		}

		override protected function onMOver(e : MouseEvent) : void {
			super.onMOver(e);
			if (!__selected) {
				__fillAlpha = 0.1;
				render();
			}
		}

		override protected function onMOut(e : MouseEvent) : void {
			super.onMOut(e);
			if (!__selected) {
				__fillAlpha = 0;
				render();
			}
		}
	}
}