package com.fuelindustries.net.assetmanager.core.assets {
	import com.fuelindustries.net.assetmanager.core.assets.abstract.AbstractLoaderAsset;

	/**
	 * @author jkeon
	 */
	public class BitmapAsset extends AbstractLoaderAsset {
		public function BitmapAsset(_assetName : String, _path : String) {
			super(_assetName, _path);
			__fileType = "bitmap";
		}
		
		public override function getFile():* {
			return __loader.content;
		}
	}
}
