package com.module_assets.net.assets {
	import com.module_assets.net.assets.abstract.AbstractURLLoaderAsset;		

	/**
	 * @author jkeon
	 */
	public class XMLAsset extends AbstractURLLoaderAsset {
		
		
		
		public function XMLAsset(_assetName:String, _path:String) {
			super(_assetName, _path);
			__fileType = "xml";
		}
		
		public override function getFile():* {
			//Returns the XML File
			return new XML(__loader.data);
		}
		
	
		
	}
}
