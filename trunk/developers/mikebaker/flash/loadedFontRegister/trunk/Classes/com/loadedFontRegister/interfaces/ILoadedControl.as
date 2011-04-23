package com.loadedFontRegister.interfaces {
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;

	/**
	 * @author Mike
	 */
	public interface ILoadedControl
	{
		function init(_appDomainOverride:ApplicationDomain = null):void
		
		function get display():DisplayObject;
	}
}
