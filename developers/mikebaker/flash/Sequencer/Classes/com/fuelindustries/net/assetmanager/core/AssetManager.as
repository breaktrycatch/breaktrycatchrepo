package com.fuelindustries.net.assetmanager.core {
	import com.fuelindustries.net.assetmanager.events.AssetCompleteEvent;
	import com.fuelindustries.net.assetmanager.events.AssetProgressEvent;
	import com.fuelindustries.net.assetmanager.events.AssetQueueEvent;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * The AssetManager handles all of your loading and instantiating needs.
	 * 
	 * @author jkeon
	 */
	public class AssetManager extends EventDispatcher {
		
		//Holds an instance of itself
		private static var __instance:AssetManager;
		
		//Holds all the groups
		protected var __groups:Array;
		//Holds all the queues
		protected var __queues:Dictionary;
		//Holds all the libraries
		protected var __libraries:Dictionary;
		
		//Temp Variables for referencing a Group or Queue	
		protected var __tempGroup:AssetGroup;
		protected var __tempQueue:AssetQueue;
		
		
		/**
		 * Constructor for AssetManager
		 * 
		 * @throws Error when trying to instantiate more than once.
		 */
		public function AssetManager(target : IEventDispatcher = null) {
			if (__instance == null) {
				super(target);
				__groups = [];
				__libraries = new Dictionary(true);
				__queues = new Dictionary(true);
			}
			else {
				throw (new Error("[ASSET MANAGER::Constructor] - Can't Instantiate More than Once"));
			}
		}
		
		
		/**
		 * Gets the static instance of the Asset Manager
		 * 
		 * @return Instance of the Asset Manager
		 */
		public static function getInstance():AssetManager {
			if (__instance == null) {
				__instance = new AssetManager();
			}
			
			return __instance;
		}
		
		
		
		/**
		 * Adds the Asset to the Manager to be loaded. Returns the AssetName so you can reference it later if you need to.
		 * 
		 * @param _path The path to load the asset file
		 * @param _group The group the asset should be a part of
		 * 
		 * @return The assetname as a string as it is stored in the libraries dictionary
		 */
		public function addAsset(_path:String, _group:int, _assetName:String = ""):String {
			
			//Determines the assetname by slicing off the path and file extension
			var assetName:String = (_assetName == "") ? _path : _assetName;
			if (__libraries[assetName] != null) {
				throw new Error("Asset " + assetName + " already exists!");
			}
			__libraries[assetName] = _group;

			//If there isn't a group already created
			if (__groups[_group] == null) {
				//create one
				__tempGroup = new AssetGroup(_group);
				__groups[_group] = __tempGroup;
			}
			else {
				//otherwise get the group
				__tempGroup = __groups[_group];
			}
			//Add the asset to the group
			__tempGroup.addAsset(_path);
			
			return assetName;
		}
		
		/**
		 * Creates a Queue to load a certain set of groups in order
		 * 
		 * @param _queueName The String name of the Queue
		 * @param _groups An Array of Group Indexes
		 * 
		 * @throws Error if the group is not valid or if the queue has no valid groups
		 */
		public function createQueue(_queueName:String, _groups:Array):void {
			
			var orderedGroups:Array = [];
			for (var i:int = _groups.length - 1; i >= 0; i--) {
				__tempGroup = __groups[_groups[i]];
				if (__tempGroup != null) {
					__tempGroup.queued = true;
					orderedGroups.push(__tempGroup);
				}
				else {
					throw (new Error("[ASSET MANAGER::createQueue] - Group " + _groups[i] + " is not a valid group."));
				}
			}
			
			if (orderedGroups.length > 0) {
				__tempQueue = new AssetQueue(_queueName, orderedGroups);
				__queues[_queueName] = __tempQueue;
			}
			else {
				throw (new Error("[ASSET MANAGER::createQueue] - Queue " + _queueName + " has no valid groups"));
			}
		}
		
		
		/**
		 * Loads a Group of Assets by the Group Index. By default it will prep the assets by downloading a bit of each one to get the final filesize. This will look like you are downloading each item twice in Charles.
		 * 
		 * @param _group The Group Id you wish to load
		 * @param _prep Boolean to determine whether you want to prep the assets or not.
		 * 
		 * @throws Error if the group does not exist
		 */
		public function loadGroup(_group:int, _prep:Boolean = true):void {
			//Tell the group to load itself
			__tempGroup = __groups[_group];
			if (__tempGroup != null) {
				__tempGroup.addEventListener(AssetProgressEvent.PROGRESS, onProgress);
				__tempGroup.addEventListener(AssetCompleteEvent.COMPLETE, onComplete);
				__tempGroup.load(_prep);
			}
			else {
				throw (new Error("[ASSET MANAGER::loadGroup] - Group " + _group + " does not exist."));
			}
		}
		
		/**
		 * Loads a Queue of Groups by the QueueName. By default it will prep the assets by downloading a bit of each one to get the final filesize. This will look like you are downloading each item twice in Charles.
		 * 
		 * @param _queueName The name of the Queue you wish to load
		 * @param _prep Boolean to determine whether you want to prep the assets or not.
		 * 
		 * @throws Error if the Queue does not exist.
		 */
		public function loadQueue(_queueName:String, _prep:Boolean = true):void {
			__tempQueue = __queues[_queueName];
			if (__tempQueue != null) {
				__tempQueue.addEventListener(AssetProgressEvent.PROGRESS, onProgress);
				__tempQueue.addEventListener(AssetCompleteEvent.COMPLETE, onComplete);
				__tempQueue.addEventListener(AssetQueueEvent.COMPLETE, onQueueComplete);
				__tempQueue.load(_prep);
			}
			else {
				throw (new Error("[ASSET MANAGER::loadQueue] - Queue " + _queueName + " does not exist."));
			}
		}
		
		
		/**
		 * Stops loading a group by the group id.
		 * 
		 * @param _group The group id you wish to pause.
		 * 
		 * @throws Error if the group does not exist.
		 */
		public function pauseGroup(_group:int) : void {
			//Tell the group to pause itself
			__tempGroup = __groups[_group];
			if (__tempGroup != null) {
				__tempGroup.removeEventListener(AssetProgressEvent.PROGRESS, onProgress);
				__tempGroup.removeEventListener(AssetCompleteEvent.COMPLETE, onComplete);
				__tempGroup.pause();
			}
			else {
				throw (new Error("[ASSET MANAGER::pauseGroup] - Group " + _group + " does not exist."));
			}
		}
		
		/**
		 * Stops loading a queue by the queue name.
		 * 
		 * @param _queueName The name of the Queue you wish to pause.
		 * 
		 * @throws Error if the Queue does not exist.
		 */
		public function pauseQueue(_queueName:String):void {
			
			__tempQueue = __queues[_queueName];
			if (__tempQueue != null) {
				__tempQueue.removeEventListener(AssetProgressEvent.PROGRESS, onProgress);
				__tempQueue.removeEventListener(AssetCompleteEvent.COMPLETE, onComplete);
				__tempQueue.removeEventListener(AssetQueueEvent.COMPLETE, onQueueComplete);
				__tempQueue.pause();
			}
			else {
				throw (new Error("[ASSET MANAGER::pauseQueue] - Queue " + _queueName + " does not exist."));
			}
		
		}
		
		/**
		 * Reorders a queue by placing a certain group as the top priority
		 * 
		 * @param _queueName The name of the Queue you are reordering
		 * @param _priorityGroup The group id you wish to be first.
		 * 
		 * @throws Error if the Queue does not exist
		 */
		public function reorderQueue(_queueName:String, _priorityGroup:int):void {
			__tempQueue = __queues[_queueName];
			if (__tempQueue != null) {
				__tempQueue.reorder(_priorityGroup);
			}
			else {
				throw (new Error("[ASSET MANAGER::reorderQueue] - Queue " + _queueName + " does not exist."));
			}
		}

		
		/**
		 * Cleans a group.
		 * 
		 * @param _group The Group Id you wish to clean out.
		 */
		public function cleanGroup(_group:int):void {
			if (__groups[_group] != null) {
				__tempGroup = __groups[_group];
				__tempGroup.clean();
				__groups[_group] = null;
			}
		}
		
		/**
		 * Checks if the Group is loaded.
		 * 
		 * @param _group The Group you wish to check
		 * 
		 * @throws Error if the group does not exist.
		 * @return Whether the group is loaded (true) or not (false).
		 */
		public function isGroupLoaded(_group:int):Boolean {
			__tempGroup = __groups[_group];
			if (__tempGroup != null) {
				return __tempGroup.groupComplete;
			}
			else {
				throw (new Error("[ASSET MANAGER::isGroupLoaded] - Group " + _group + " does not exist."));
				return false;
			}
		}
		
		/**
		 * Returns the actual file of the asset you loaded. (SWF, XML, etc) You will have to cast it when you recieve it.
		 * 
		 * @param _fileName The name of the asset you are trying to get back
		 * 
		 * @throws Error is file does not exist
		 * @return The file
		 */
		public function getFile(_fileName:String):* {
			__tempGroup = __groups[__libraries[_fileName]];
			var file:* = __tempGroup.getFile(_fileName);
			if (file != null) {
				return file;
			}
			else {
				throw (new Error("[ASSET MANAGER::getFile] - File does not exist " + _fileName));
			}
		}
		
		/**
		 * Returns the asset from the library. Can either be a class or string linkage
		 * 
		 * @param _asset The Class name or String linkage of the asset
		 * @return The asset
		 */
		public function getAsset(_asset:*, _isBitmapData:Boolean = false):* {
		
			var sClass:*;
			if (_asset is String) {
				sClass = _asset;
			}
			else if (_asset is Class) {
				sClass = getQualifiedClassName(_asset);
			}
			return constructAsset(sClass, _isBitmapData);
		}
		
		/**
		 * Constructs the asset based on a Class or String Linkage
		 * 
		 * @param _asset The Class name or String linkage of the asset
		 * 
		 * @throws Error if the asset does not exist
		 * @return The Asset
		 */
		protected function constructAsset(_asset:*, _isBitmapData:Boolean = false):* {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			
			if (appDomain.hasDefinition(_asset)) {
				var cls:Class = appDomain.getDefinition(_asset) as Class;
				var inst:*;
				if (_isBitmapData) {
					inst = new cls(0,0);
				}
				else {
					inst = new cls();
				}
				return inst;
			}
			else {
				throw (new Error("[ASSET MANAGER::constructAsset] - Cannot construct Asset " + _asset));
				return null;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		


		/**
		 * When Progress Events are dispatched
		 * 
		 * @param e The Progress Event
		 */
		protected function onProgress(e:AssetProgressEvent):void {
			//Wipes the initial event and pushes it through
			e.stopImmediatePropagation();
			dispatchEvent(new AssetProgressEvent(e.type, e.bytesLoaded, e.bytesTotal, e.group));
			e = null;
		}
		/**
		 * When Complete Events are dispatched
		 * 
		 * @param e The Complete Event
		 */
		protected function onComplete(e:AssetCompleteEvent):void {
			//Wipes the initial event and pushes it through
			e.stopImmediatePropagation();
			dispatchEvent(new AssetCompleteEvent(e.type, e.group));
			e = null;
		}
		/**
		 * When Queue Events are dispatched
		 * 
		 * @param e The Queue Event
		 */
		protected function onQueueComplete(e:AssetQueueEvent):void {
			//Wipes the initial event and pushes it through
			e.stopImmediatePropagation();
			dispatchEvent(new AssetQueueEvent(e.type, e.queueName));
			e = null;
		}
		
		
		
	}
}
