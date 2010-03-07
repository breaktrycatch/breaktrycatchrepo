package com.fuelindustries.net.assetmanager.core {
	import com.fuelindustries.net.assetmanager.events.AssetCompleteEvent;
	import com.fuelindustries.net.assetmanager.events.AssetProgressEvent;
	import com.fuelindustries.net.assetmanager.events.AssetQueueEvent;

	import flash.events.EventDispatcher;

	/**
	 * @author jkeon
	 */
	public class AssetQueue extends EventDispatcher {
		
		
		protected var __queue:Array;
		protected var __completedGroups:Array;
		protected var __activeGroup:AssetGroup;
		protected var __queueName:String;
		
		public function AssetQueue(_queueName:String, _queue:Array) {
			super();
			__completedGroups = [];
			__queueName = _queueName;
			__queue = _queue;
			__activeGroup = _queue[_queue.length - 1];
		}
		
		public function load(_prep:Boolean = true):void {
			//If we have a group to load
			if (__activeGroup != null) {
				
				//if the item is already loading for some reason
				if (__activeGroup.loading) {
					//just make sure it's part of a queue
					__activeGroup.queued = true;
				}
				else {
					//Load the Group
					__activeGroup.addEventListener(AssetProgressEvent.PROGRESS, onProgress);
					__activeGroup.addEventListener(AssetCompleteEvent.COMPLETE, onComplete);
					__activeGroup.load(_prep);
				}
				
			}
			else {
				//Queue is empty
				trace("[ASSETQUEUE " + __queueName + "] - Queue is currently empty");
			}
		}
		
		public function pause():void {
			__activeGroup.removeEventListener(AssetProgressEvent.PROGRESS, onProgress);
			__activeGroup.removeEventListener(AssetCompleteEvent.COMPLETE, onComplete);
			__activeGroup.pause();
		}
		
		
		public function reorder(_group:int):void {
			
			
			if (__activeGroup.groupId != _group) {
				
				//Check and see if the active group is midloading
				if (__activeGroup.loading) {
					//If it is, then pause it.
					pause();
				}
				
				
				var searchGroup:AssetGroup;
				var tempGroup:AssetGroup;
				//Search the queue for the group
				for (var i:int = __queue.length - 1; i >= 0; i--) {
					searchGroup = __queue[i];
					if (searchGroup.groupId == _group) {
						//pull the group out of the queue
						tempGroup = __queue[i];
						__queue.splice(i, 1);
						break;
					}
				}
				
				if (tempGroup != null) {
					//push it onto the array
					__queue.push(tempGroup);
				}
				else {
					
					var flag:Boolean = false;
					for (var b in __completedGroups) {
						searchGroup = __completedGroups[b];
						if (searchGroup.groupId == _group) {
							trace("[ASSETQUEUE " + __queueName + "] - Group " + _group + " is already loaded.");
							flag = true;
							break;
						}
					}
					if (flag == false) {
						trace("[ASSETQUEUE " + __queueName + "] - Group " + _group + " was never part of queue.");
					}
				}
				
				//Set the active group
				__activeGroup = __queue[__queue.length - 1];
				//resume loading
				load();
			}
		}
		
		
		
		
		
		public function onProgress(e:AssetProgressEvent):void {
			e.stopImmediatePropagation();
			dispatchEvent(new AssetProgressEvent(e.type, e.bytesLoaded, e.bytesTotal, e.group));
			e = null;
		}
		
		public function onComplete(e:AssetCompleteEvent):void {
			e.stopImmediatePropagation();
			
			var queueComplete:Boolean = false;
			
			//Group is complete, pop it off the queue
			__completedGroups.push(__queue.pop());
			if (__queue.length > 0) {
				__activeGroup = __queue[__queue.length - 1];
				load();
			}
			else {
				queueComplete = true;
			}
			dispatchEvent(new AssetCompleteEvent(e.type, e.group));
			e = null;
			
			if (queueComplete) {
				trace("[ASSETQUEUE " + __queueName + "] - Queue is complete. All Groups loaded");
				dispatchEvent(new AssetQueueEvent(AssetQueueEvent.COMPLETE, __queueName));
			}
		}
		
		
	}
}
