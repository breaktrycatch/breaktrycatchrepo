package com.loadedFontRegister.main {
	import com.loadedFontRegister.main.control.LoadControl;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Mike
	 */
	public class LoadedFontRegisterCore extends MovieClip 
	{
		public var brokenLoadedFont_mc:LoadControl;
		public var workingLoadedFont_mc:LoadControl;
		
		private var file:String = 'loadedFontRegister_loaded.swf';
		
		public function LoadedFontRegisterCore()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			//in a moderately gross way set an absolute path to the loaded swf
			var path:String = stage.loaderInfo.url.replace('loadedFontRegister_main.swf', file);
			path = path.replace('loadedFontRegister%5Fmain.swf', file);

			workingLoadedFont_mc.init(path, true, "Register Font on Host Application Domain");
			brokenLoadedFont_mc.init(path, false, "Register Font on Current Application Domain");
		}
	}
}
