package com.loadedFontRegister.loaded {
	import flash.text.TextFormat;
	import com.loadedFontRegister.interfaces.ILoadedControl;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Mike
	 */
	public class LoadedClipCore extends MovieClip implements ILoadedControl 
	{
		private static const FONT_LINKAGE:String = "dynamic_fnt";
		
		public var label_txt:TextField;
		
		public function LoadedClipCore()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function init(_appDomainOverride : ApplicationDomain = null) : void
		{
			var fontClass:Class = getDefinitionByName(FONT_LINKAGE) as Class;
			
			try
			{
				if(_appDomainOverride)
				{
					_appDomainOverride.getDefinition('flash.text.Font')['registerFont'](fontClass);
				}
				else
				{
					Font.registerFont(fontClass);
				}
				
				label_txt.text = "Font Registered!";
				
				var format:TextFormat = label_txt.getTextFormat();
				var font:Font = new fontClass();
				format.font = font.fontName;
				label_txt.defaultTextFormat = format;
				label_txt.embedFonts = true;
				label_txt.setTextFormat(format);
			}
			catch(e:ArgumentError)
			{
				label_txt.text = e.message;
				label_txt.textColor = 0xFF0000;
			}
		}
		
		public function get display() : DisplayObject
		{
			return this;
		}
	}
}
