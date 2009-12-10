package com.valkryie.view {
	import com.valkryie.environment.SandboxEnvironment;

	/**
	 * @author jkeon
	 */
	public class SandboxView extends BaseView {
		
		protected var __environment:SandboxEnvironment;
		
		public function SandboxView() {
			super();
			linkage = "View_Sandbox";
		}

		override protected function onAdded() : void {
			super.onAdded();
			init();
			
		}
		
		protected function init():void {
			
			__environment = new SandboxEnvironment();
			__environment.linkDisplay();
			__environment.y = 50;
			addChild(__environment.display);
			
			__environment.renderGeometry();
						
		}
		
	}
}
