package com.fuelindustries.net 
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/*
	XML delegate retrieves XML and saves it the xml property.
	Resusable class.
	*/
	public class XMLDelegate extends EventDispatcher
	{
		public static const EVENT_LOADED:String="onLoaded";
		private var __xml:XML;
		
		public function XMLDelegate()
		{
			super();
		}
		/*
		Load the XML 
		*/
		public function load(p_url:String):void
		{
		     var request:URLRequest = new URLRequest(p_url);
		     var loader:URLLoader = new URLLoader();
		     loader.addEventListener(Event.COMPLETE,onComplete);
		   
		     
		     try
		     {
		     	loader.load(request);
		     }
		     catch(error:ArgumentError)
		     {
		     	trace("XMLDelegate::Error:: an argument error occurred");
		     }
		     catch(error:SecurityError)
		     {
		        trace("XMLDelegate::Error:: a security error occurred");
		     }
		     
		      catch(error:IOError)
		     {
		        trace("XMLDelegate::Error:: and IOError occurred");
		     }
		}
		
		private function onComplete(p_event:Event):void
		{
			 var l:URLLoader = p_event.target as URLLoader;
		     xml  = XML(l.data);
		     l.removeEventListener(Event.COMPLETE,onComplete);
		     // Disptach the complete
		     var event:Event = new Event(EVENT_LOADED);
		     dispatchEvent(event);
		}
		
		public function get xml():XML
		{
			return(__xml);
		}
		public function set xml(p_xml:XML):void
		{
			__xml= p_xml;
		}
		
	}
}