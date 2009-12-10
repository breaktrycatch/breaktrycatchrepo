package com.module_assets.net.assets {
	import com.module_assets.net.assets.abstract.AbstractSoundAsset;		

	/**
	 * @author jkeon
	 */
	public class MP3Asset extends AbstractSoundAsset {
		public function MP3Asset(_assetName : String, _path : String) {
			super(_assetName, _path);
			__fileType = "mp3";
			//Actually don't have a use for this class... Since SoundManager has addMP3Stream... Not sure why it was created.
		}
		
		public override function getFile():* {
			return __loader;
		}
	}
}
