package com.fuelindustries.media 
{
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.VideoPlayerEvent;
	import com.fuelindustries.media.video.VideoProgressBar;

	import flash.events.MouseEvent;

	/**
	 * @author sjohn
	 */
	public class VideoPlayerControls extends FuelUI {
		//VARIABLES
		
		//The background of the controls
		public var background_mc:FuelUI;
		
		//Pause Button
		public var pause_btn:SimpleButton;
		//Resume Button
		public var resume_btn:SimpleButton;
		//Rewind Button 
		//public var rewind_btn:SimpleButton;
		//Mute Button
		public var mute_btn:SimpleButton;
		//Mute Down Button
		public var mutedown_btn:SimpleButton;
		//Full Screen Button
		//public var fullscreen_btn:SimpleButton;
		//Full Screen Down Button
		//public var fullscreendown_btn:SimpleButton;
		//Progress Timer
		//public var timer_mc:MovieClip;
		
		//Progress Bar
		public var progress_mc:VideoProgressBar;
		
		//Whether the controls are showing or not
		protected var __isShowing:Boolean;
		
		protected var mute_offset:Number;
		protected var fullscreen_offset:Number;
		protected var timer_offset:Number;
		
		//CONSTRUCTOR
		public function VideoPlayerControls() {
			super();
			//we don't need these buttons on the stage right now
			removeChild(mutedown_btn.display);
			//removeChild(fullscreendown_btn);
			removeChild(resume_btn.display);
			//removeChild(timer_mc);
			
			//we don't want to be pausing and resuming a video that hasn't started streaming yet
			pause_btn.enabled = false;
			resume_btn.enabled = false;
			
			//add listeners
			pause_btn.addEventListener(MouseEvent.CLICK, onPauseClick);
			resume_btn.addEventListener(MouseEvent.CLICK, onResumeClick);
			//fullscreen_btn.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			//fullscreendown_btn.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			mute_btn.addEventListener(MouseEvent.CLICK, onMuteClick);
			mutedown_btn.addEventListener(MouseEvent.CLICK, onMuteClick);
			//rewind_btn.addEventListener(MouseEvent.CLICK, onRewindClick);
			
		
			mute_offset = background_mc.width - mute_btn.x;
			//fullscreen_offset = background_mc.width - fullscreen_btn.x;
			//timer_offset = background_mc.width - timer_mc.x;
			//timer_mc.timer_txt.text = "00:00/00:00";
			
			
		}
		
		

		
		//GETTERS
		
		//Whether we are showing the controls or not
		public function get isShowing():Boolean {
			return __isShowing;	
		}
		
		//SETTERS
		
		//Tell the controls to show or hide
		public function set isShowing(_bool:Boolean):void {
			__isShowing = _bool;
			if (__isShowing == true) {
				show();
			}
			else {
				hide();
			}
		}
		
		//Enable the Pause and Resume functionality
		public function enablePauseResume():void {
			pause_btn.enabled = true;
			resume_btn.enabled = true;	
		}
		
		//FUNCTIONALITY
		
		public function revertToMin():void {
//			if (fullscreendown_btn.parent) {
//				removeChild(fullscreendown_btn);
//			}
//			addChild(fullscreen_btn);
		}
		
		//Show the Controls
		public function show():void {
			if (!__isShowing) {
				__isShowing = true;
				this.alphaTo(100, 500, "ease");
			}
		}
		
		//Hide the Controls
		public function hide():void {
			if (__isShowing) {
				__isShowing = false;
				this.alphaTo(0, 500, "ease");
			}
		}
		
		public function pauseToPlay():void {
			if (pause_btn.parent) {
				removeChild(pause_btn.display);
			}
			if (!resume_btn.parent) {
				addChild(resume_btn.display);
			}
		}
		
		
		protected function onResumeClick(e:MouseEvent):void {
			
			removeChild(resume_btn.display);
			addChild(pause_btn.display);
		
			dispatchEvent(new VideoPlayerEvent("resume", true));
		}
		
		protected function onPauseClick(e:MouseEvent):void {
			
			removeChild(pause_btn.display);
			addChild(resume_btn.display);
		
			dispatchEvent(new VideoPlayerEvent("pause"));
		}
		
		protected function onFullScreenClick(e:MouseEvent):void {
//			if (fullscreen_btn.parent) {
//				removeChild(fullscreen_btn);
//				addChild(fullscreendown_btn);
//			}
//			else {
//				removeChild(fullscreendown_btn);
//				addChild(fullscreen_btn);
//			}
			dispatchEvent(new VideoPlayerEvent("fullscreen"));	
		}
		
		protected function onMuteClick(e:MouseEvent):void {
			if (mute_btn.parent) {
				removeChild(mute_btn.display);
				addChild(mutedown_btn.display);
			}
			else {
				removeChild(mutedown_btn.display);
				addChild(mute_btn.display);
			}
			dispatchEvent(new VideoPlayerEvent("mute", true));	
		}
		
//		protected function onRewindClick(e:MouseEvent):void {
//			dispatchEvent(new VideoPlayerEvent("rewind"));	
//		}
		
		
		public function updateProgress(_bytesLoaded:int, _bytesTotal:int, _time:Number, _duration:Number, _mode:String):void {
			progress_mc.updateProgress(_bytesLoaded, _bytesTotal, _time, _duration);
			
			if (_mode == "MAX") {
				
				var min:int = (_time/60);
				var sec:int = (_time - (min * 60));
				var sMin:String;
				var sSec:String;
				if (min < 10) {
					sMin = "0" + min;
				}
				else {
					sMin = String(min);
				}
				if (sec < 10) {
					sSec = "0" + sec;
				}
				else {
					sSec = String(sec);
				}
				
				var dmin:int = (_duration/60);
				var dsec:int = (_duration - (dmin * 60));
				var sdMin:String;
				var sdSec:String;
				if (dmin < 10) {
					sdMin = "0" + dmin;
				}
				else {
					sdMin = String(dmin);
				}
				if (dsec < 10) {
					sdSec = "0" + dsec;
				}
				else {
					sdSec = String(dsec);
				}
				
				
				//timer_mc.timer_txt.text = sMin + ":" + sSec + "/" + sdMin + ":" + sdSec;
			}
			
		}
		
		
		
		
		public function resize(_newWidth:Number, _btnWidth:Number):void {
			
			
			
			background_mc.width = _newWidth;
			
			
			//fullscreen_btn.x = _btnWidth - fullscreen_offset;
			//fullscreendown_btn.x = _btnWidth - fullscreen_offset;
			mute_btn.x = _btnWidth- mute_offset;
			mutedown_btn.x = _btnWidth - mute_offset;
			//timer_mc.x = _btnWidth - timer_offset;
			var targetWidth:Number;
			
			if (_newWidth != _btnWidth) {
				//addChild(timer_mc);
				//targetWidth = timer_mc.x - (pause_btn.x + pause_btn.width) - 11.5;
			}
			else {
//				if (timer_mc.parent) {
//					removeChild(timer_mc);
//				}
				targetWidth = mute_btn.x - (pause_btn.x + pause_btn.width) - 11.5;
			}
			
//			progress_mc.resize(targetWidth);
			
		
		}
		
		
	}
}
