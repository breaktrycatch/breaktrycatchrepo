package com.adobe.kuler 
{
	import com.adobe.kuler.events.*;	
	import com.adobe.kuler.params.SearchParams;
	import com.adobe.kuler.swatches.Swatches;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched after searchSwatches is finished. 
	 *  @eventType com.adobe.kuler.events.SearchResultEvent
	 */
	[Event(name="searchResult", type="com.adobe.kuler.events.SearchResultEvent")]
	
	/**
	 *  Dispatched after a result is finished.
	 *  @eventType com.adobe.kuler.events.GetResultEvent
	 */
	[Event(name="getResult", type="com.adobe.kuler.events.GetResultEvent")]


	/**
	 * K-Lib API Service Class. This class is the main entrypoint into the K-Lib AS3 Library. 
	 * 
	 * <p>
	 * You must aggree to the Kuler Terms of Use found at <a href='http://kuler.adobe.com/links/kuler_terms_of_use.html'> http://kuler.adobe.com/links/kuler_terms_of_use.html</a> before using K-Lib.<br />
	 * Any use of K-Lib in whole or in part is bound to the terms set by adobe found in the link above.<br />
	 * To utilize K-Lib you must also aquire a Kuler API key, You can learn more about this at <a href='http://learn.adobe.com/wiki/display/kulerdev/A.+Kuler+API+Documentation'> http://learn.adobe.com/wiki/display/kulerdev/A.+Kuler+API+Documentation</a></p>
	 *  
	 * @author Josh Chernoff
	 * @version 0.2
	 * 
	 */
	
	public class KLibService implements IEventDispatcher
	{
		private const API_URL:String 	= "http://kuler-api.adobe.com/";
		private const GET_URL:String 	= "rss/get.cfm?";
		private const SEARCH_URL:String = "rss/search.cfm?";
		
		private var _key:String;
		
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		
		private var dispatcher:EventDispatcher;
		
		//private var _swatches:Swatches;	
		
		
		/**
		 * Creates a new KLibService instance.
		 * @param	key:String This is the API key that adobed provided you.
		 */
		
		public function KLibService(key:String) 
		{
			_key = key;
			dispatcher = new EventDispatcher(this);
		}
		
		//--------------------------------------
		//  Public methods 
		//--------------------------------------
		
		/**
		 * Get highest-rated Swatches
		 * @param	startIndex A 0-based index into the list that specifies the first item to display. Default is 0, which displays the first item in the list.
		 * @param	itemsPerPage The maximum number of items to display on a page, in the range 1..100. Default is 20.
		 * @param	timeSpan Value in days to limit the set of themes retrieved. Default is 0, which retrieves all themes without time limit.
		 * @throws 	May throw a SECURITY_ERROR if sandbox secrutiry is broken.
		 * @throws	May throw a IO_ERROR is API services are down or if network connections are down
		 */
		public function getHighestRated(startIndex:int = 0, itemsPerPage:int = 20, timeSpan:int = 0):void
		{
			_urlRequest = new URLRequest(API_URL + GET_URL + "listType=rating&startIndex=" + startIndex + "&itemsPerPage=" + itemsPerPage + "&timeSpan=" + timeSpan + "&key=" + _key);
			_urlLoader = new URLLoader();
			configURLLoader(_urlLoader);
			_urlLoader.load(_urlRequest);			
		}		
		
		/**
		 * Get most popular Swatches
		 * @param	startIndex A 0-based index into the list that specifies the first item to display. Default is 0, which displays the first item in the list.
		 * @param	itemsPerPage The maximum number of items to display on a page, in the range 1..100. Default is 20.
		 * @param	timeSpan Value in days to limit the set of themes retrieved. Default is 0, which retrieves all themes without time limit.
		 * @throws 	May throw a SECURITY_ERROR if sandbox secrutiry is broken.
		 * @throws	May throw a IO_ERROR is API services are down or if network connections are down
		 */
		public function getPopular(startIndex:int = 0, itemsPerPage:int = 20, timeSpan:int = 0):void
		{
			_urlRequest = new URLRequest(API_URL + GET_URL + "listType=popular&startIndex=" + startIndex + "&itemsPerPage=" + itemsPerPage + "&timeSpan=" + timeSpan + "&key=" + _key);
			_urlLoader = new URLLoader();
			configURLLoader(_urlLoader);
			_urlLoader.load(_urlRequest);
		}
		
		/**
		 * Get most recent Swatches
		 * @param	startIndex A 0-based index into the list that specifies the first item to display. Default is 0, which displays the first item in the list.
		 * @param	itemsPerPage The maximum number of items to display on a page, in the range 1..100. Default is 20.
		 * @param	timeSpan Value in days to limit the set of themes retrieved. Default is 0, which retrieves all themes without time limit.
		 * @throws 	May throw a SECURITY_ERROR if sandbox secrutiry is broken.
		 * @throws	May throw a IO_ERROR is API services are down or if network connections are down
		 */
		public function getRecent(startIndex:int = 0, itemsPerPage:int = 20, timeSpan:int = 0):void
		{
			_urlRequest = new URLRequest(API_URL + GET_URL + "listType=recent&startIndex=" + startIndex + "&itemsPerPage=" + itemsPerPage + "&timeSpan=" + timeSpan + "&key=" + _key);
			_urlLoader = new URLLoader();
			configURLLoader(_urlLoader);
			_urlLoader.load(_urlRequest);
		}
		
		/**
		 * Get most random  feeds
		 * @param	startIndex A 0-based index into the list that specifies the first item to display. Default is 0, which displays the first item in the list.
		 * @param	itemsPerPage The maximum number of items to display on a page, in the range 1..100. Default is 20.
		 * @param	timeSpan Value in days to limit the set of themes retrieved. Default is 0, which retrieves all themes without time limit.
		 * @throws 	May throw a SECURITY_ERROR if sandbox secrutiry is broken.
		 * @throws	May throw a IO_ERROR is API services are down or if network connections are down
		 */
		public function getRandom (startIndex:int = 0, itemsPerPage:int = 20, timeSpan:int = 0):void
		{
			_urlRequest = new URLRequest(API_URL + GET_URL + "listType=random&startIndex=" + startIndex + "&itemsPerPage=" + itemsPerPage + "&timeSpan=" + timeSpan + "&key=" + _key);
			_urlLoader = new URLLoader();
			configURLLoader(_urlLoader);
			_urlLoader.load(_urlRequest);
		}
		
		/**
		 * Search swatches based off of the SearchParams Object
		 * @param	SearchParams
		 * @see 	com.adobe.kuler.params.SearchParams
		 */
		public function searchSwatches(searchQuery:SearchParams, startIndex:int = 0, itemsPerPage:int = 20, timeSpan:int = 0):void
		{
			_urlRequest = new URLRequest(API_URL + SEARCH_URL + searchQuery + "&startIndex=" + startIndex + "&itemsPerPage=" + itemsPerPage + "&timeSpan=" + timeSpan + "&key=" + _key);
			trace(_urlRequest.url);
			_urlLoader = new URLLoader();
			configURLLoader(_urlLoader);
			_urlLoader.load(_urlRequest);
		}
		
		//--------------------------------------
		//  Methods for URLLoader
		//--------------------------------------
		private function configURLLoader(loader:IEventDispatcher):void
		{
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.addEventListener(Event.OPEN, onLoaderOpen);
			loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoaderHttpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
			
		}
		
		private function onLoaderSecurityError(e:SecurityErrorEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function onLoaderIOError(e:IOErrorEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function onLoaderHttpStatus(e:HTTPStatusEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function onLoaderProgress(e:ProgressEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function onLoaderOpen(e:Event):void 
		{
			this.dispatchEvent(e);
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			var xml:XML = XML(e.target.data);
			var swatches:Swatches = new Swatches(xml);
			this.dispatchEvent(new GetResultEvent(xml.channel.recordCount, swatches, GetResultEvent.GET_RESULTS));
		}
		
		//--------------------------------------
		//  Methods for IEventDispatcher implament ::Do not remove::
		//--------------------------------------
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}	
}