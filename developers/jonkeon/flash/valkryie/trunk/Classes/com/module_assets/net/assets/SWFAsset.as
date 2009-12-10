package com.module_assets.net.assets {
	import com.module_assets.net.assets.abstract.AbstractLoaderAsset;	

	/**
	 * @author jkeon
	 */
	public class SWFAsset extends AbstractLoaderAsset {
		
		public function SWFAsset(_assetName:String, _path:String) {
			super(_assetName, _path);
			__fileType = "swf";
		}
		
		public override function getFile():* {
			return __loader.content;
		}
		
	}
}
