package com.valkryie.actor.geometric {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.StaticActor;
	import com.valkryie.data.vo.geometric.EdgeVO;

	/**
	 * @author Jon
	 */
	public class EdgeActor extends StaticActor {
		public function EdgeActor() {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			super();
		}
		
		protected override function init():void {
			super.init();
			__stringName = "EDGE " + __id;
		}
		
		override protected function completeConstruction() : void {
			super.completeConstruction();
		}
		
		override protected function setupData() : void {
			__dataVO = new EdgeVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
		}
	}
}
