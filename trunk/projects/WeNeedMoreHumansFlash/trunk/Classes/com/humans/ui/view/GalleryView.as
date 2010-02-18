package com.humans.ui.view {
	import caurina.transitions.Tweener;

	import twitter.api.Twitter;
	import twitter.api.data.TwitterStatus;
	import twitter.api.events.TwitterEvent;

	import flash.display.MovieClip;

	/**
	 * @author jkeon
	 */
	public class GalleryView extends BaseView {
		
		protected var __twitter:Twitter;
		
		protected var __twitterStatuses:Array;
		protected var __activeStatus:TwitterStatus;
		
		public var monkey_ambient_mc:MovieClip;
		public var monkeyplane_ambient_mc:MovieClip;
		
		
		public function GalleryView() {
			super();
			linkage = "GalleryView_mc";
		}

		
		override protected function completeConstruction() : void {
			super.completeConstruction();
			__twitter = new Twitter();
			__twitter.addEventListener(TwitterEvent.ON_USER_TIMELINE_RESULT, onUserTimeline);
			//__twitter.loadUserTimeline("NeedMoreHumans");
		}

		
		
		override protected function onAdded() : void {
			super.onAdded();
			
			
			midMonkey();
		}
		
		
		protected function midMonkey():void {
			Tweener.addTween(monkey_ambient_mc, {x:771, time:30.0, transition:"linear", onComplete:chooseLeft});
		}
		
		protected function monkeyPlane():void {
			Tweener.addTween(monkeyplane_ambient_mc, {x:-143, time:30.0, transition:"linear", onComplete:chooseRight});
		}
		
		
		protected function chooseLeft():void {
			//Reset
			monkey_ambient_mc.x = -128;
			
			monkeyPlane();
		}
		
		protected function chooseRight():void {
			monkeyplane_ambient_mc.x = 761;
			
			midMonkey();
		}

		protected function onUserTimeline(e:TwitterEvent):void {
			__twitterStatuses = e.data as Array;
			for (var i:int = 0; i < __twitterStatuses.length; i++) {
				__activeStatus = __twitterStatuses[i];
				dtrace(__activeStatus.text);
			}
		}
		
		
		

	}
}
