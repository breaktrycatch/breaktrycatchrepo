package com.humans.ui.preloader {
	import com.fuelindustries.core.AssetProxy;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author jkeon
	 */
	public class PreloaderUI extends AssetProxy {
		
		public var bar_mc:MovieClip;
		public var track_mc:MovieClip;
		public var percentage_txt:TextField;
		
		protected var __maxWidth:Number;
		
		public function PreloaderUI() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			init();
		}

		protected function init():void {
			__maxWidth = track_mc.width;
			updatePercentage(0);
		}
		
		public function updatePercentage(_percent:Number):void {
			bar_mc.width = __maxWidth*_percent;
			percentage_txt.text = String(int(_percent*100)) + "%";
		}

		override public function destroy() : void {
			bar_mc = null;
			track_mc = null;
			percentage_txt = null;
			super.destroy();
		}
	}
}
