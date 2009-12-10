package com.module_systemtimer.core {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	/**
	 * @author jkeon
	 */
	public class SystemTimer extends EventDispatcher {
		
		private static var __instance:SystemTimer;
		
		public static var FRAMERATE:int;
		
		//Reference to the Stage
		protected var __stage:Stage;
		
		protected var __callbacks:Array;
		
		protected var __currentTime:int;
		protected var __lastTime:int;
		protected var __runningTime:int;
		protected var __timeElapsed:int;
		
		protected var __paused:Boolean;
		
		public function SystemTimer(target : IEventDispatcher = null) {
			if (__instance == null) {
				super(target);
				__callbacks = [];
				__paused = true;
			}
			else {
				throw new Error("[SYSTEMTIMER] - Can't Instantiate More than Once");
			}
		}
		
		public static function getInstance():SystemTimer {
			if (__instance == null) {
				__instance = new SystemTimer();
			}
			
			return __instance;
		}
		
		public function registerStage(_stage:Stage):void {
			__stage = _stage;
			FRAMERATE = 1000/__stage.frameRate;	
		}
		
		public function get paused():Boolean {
			return __paused;	
		}
		
		public function registerCallback(_function:Function, _trigger:int):void {
			var callback:SystemTimerCallback = new SystemTimerCallback(_function, _trigger);
			__callbacks.push(callback);	
		}
		public function removeCallback(_function:Function):void {
			var index:int = __callbacks.indexOf(_function);
			if (index != -1) {
				__callbacks.splice(index, 1);
			}	
			else {
				throw new Error("Function doesn't exist in callbacks stack");	
			}
		}
		
		public function start():void {
			if (isNaN(FRAMERATE)) {
				throw new Error("System Timer Error, You must set the stage via registerStage");	
			}
			__paused = false;
			__lastTime = getTimer();
			__runningTime = 0;
			__stage.addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		public function pause():void {
			__paused = true;
			__stage.removeEventListener(Event.ENTER_FRAME, onTick);	
		}
		
		public function resume():void {
			__paused = false;
			__lastTime = getTimer();
			__stage.addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		
		
		protected function onTick(e:Event):void {
			
			__currentTime = getTimer();
			
			__timeElapsed = __currentTime - __lastTime;
			__runningTime += __timeElapsed;
			
			var activeCallback:SystemTimerCallback;
			
			for (var i:int = 0; i < __callbacks.length; i++) {
				
				activeCallback = SystemTimerCallback(__callbacks[i]);
				if (__runningTime >= activeCallback.trigger) {
					activeCallback.fire(__runningTime);
					__runningTime -= activeCallback.trigger;
				}
					
			}	
			
			__lastTime = __currentTime;
		}
		
		
		
		
		
	}
}
