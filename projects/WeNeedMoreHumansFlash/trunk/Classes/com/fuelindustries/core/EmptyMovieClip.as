package com.fuelindustries.core
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class EmptyMovieClip extends FuelUI
	{
		private var __url:String;
		private var __content:DisplayObject;
		
		public function get content():DisplayObject
		{
			return( __content );	
		}
		
		public function EmptyMovieClip()
		{
			super();
		}
		
		public function loadMovie( url:String):void
		{
			var loader:Loader = new Loader();
            configureListeners( loader.contentLoaderInfo );
			
			__url = url;
		 
            var request:URLRequest = new URLRequest( url );
            loader.load( request );
		}
		
		private function configureListeners( dispatcher:IEventDispatcher ):void 
		{
            dispatcher.addEventListener( Event.COMPLETE, completeHandler, false, 0, true );
            dispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true );
            dispatcher.addEventListener( Event.INIT, initHandler, false, 0, true );
            dispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
            dispatcher.addEventListener( Event.OPEN, openHandler, false, 0, true );
            dispatcher.addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true );
            dispatcher.addEventListener( Event.UNLOAD, unLoadHandler, false, 0, true );
        }
                        
        private function dispatch( type:String ):void
        {
        	 dispatchEvent( new Event( type ) );
        }
        
        private function completeHandler( event:Event ):void 
        { 
            __content = event.target.content;
          	dispatch( event.type );
        }

        private function httpStatusHandler( event:HTTPStatusEvent ):void 
        {
            dispatch( event.type );
        }

        private function initHandler( event:Event ):void 
        {
            dispatch( event.type );
        }

        private function ioErrorHandler( event:IOErrorEvent ):void 
        {
            dispatch( event.type );
        }

        private function openHandler( event:Event ):void 
        {
            dispatch( event.type );
        }

        private function progressHandler( event:ProgressEvent ):void 
        {
            dispatch( event.type );
        }

        private function unLoadHandler( event:Event ):void 
        {
            dispatch( event.type );
        }

	}
}