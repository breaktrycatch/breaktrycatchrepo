package com.fuelindustries.media 
{
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.VideoPlayerEvent;
	import com.fuelindustries.events.VideoPlayerProgressEvent;
	import com.fuelindustries.tween.TweenEnterFrame;

	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author sjohn
	 */
	public class VideoPlayer extends FuelUI {
		
		//VARIABLES
		
		//Six main components - These are located in the FLA on the stage
		//The video itself
		public var video_mc:Video;
		//The buffering clip
		public var buffering_mc:FuelUI;
		//The controls clip
		public var controls_mc:VideoPlayerControls;
		//The background clip
		public var background_mc:FuelUI;
		//Play Button - On Video Screen
		//public var play_btn:EaseButton;
		//Replay Button - On Video Screen
		//public var replay_btn:EaseButton;
		
		
		//The net stream object
		protected var ns:NetStream;
		//The net connection object
		protected var nc:NetConnection;
		
		//The small buffer size (seconds? I believe)
		protected const SMALL_BUFFER:int = 5;
		//The large buffer size 
		protected const LARGE_BUFFER:int = 30;
		
		//The duration of the video (in seconds)
		protected var __duration:Number;
		//The URL to load the video from externally (can be passed in)
		protected var __url:String;
		//Whether we are in Fullscreen or Minimized version (MIN or MAX)
		protected var __mode:String;
		//The width of the video (can be passed in, or defaults to 320)
		protected var __vWidth:Number;
		//The height of the video (can be passed in, or defaults to 240)
		protected var __vHeight:Number;
		//Whether the video is muted or not
		protected var __mute:Boolean;
		
		
		//The original coordinates of the video if going from fullscreen to small screen
		protected var videoCo:Rectangle;
		//The original coordinates of the background
		protected var backgroundCo:Rectangle;
		
		//The original location of the video in its parent.
		protected var __oX:Number;
		protected var __oY:Number;
		
		protected var dragStatus:Boolean;
		
		private var done:Boolean;
		
		
		//CONSTRUCTOR - Sets up basic functionality
		public function VideoPlayer() {
			super();
			
			
			
			//Set the net connection object
			nc = new NetConnection();
			//Connect to nothing
			nc.connect( null );
			//create a new stream off the connection
			ns = new NetStream( nc );
			//default to the small buffer time
			ns.bufferTime = SMALL_BUFFER;
			//listen for netStatus
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			//listen for an Input/Output error
			ns.addEventListener(IOErrorEvent.IO_ERROR, onError);
			//set the client to be itself
			ns.client = this;
			
			//attach the stream to the video
			video_mc.attachNetStream( ns );
			
			//default to minimized version of video
			__mode = "MIN";
			
			//initializes the buffer clip
			buffering_mc.alpha = 0;
			//removes it from the stage, we don't need it now
			removeChild(buffering_mc.display);
			//removeChild(replay_btn);
			
			//LISTENERS
			//Play button
			//play_btn.addEventListener(MouseEvent.CLICK, onPlay);
			//removeChild(play_btn);
			
			//Listen for all controls
			controls_mc.addEventListener(VideoPlayerEvent.FULLSCREEN, onFullScreen);
			controls_mc.addEventListener(VideoPlayerEvent.MUTE, onMute);
			controls_mc.addEventListener(VideoPlayerEvent.PAUSE, onPause);
			controls_mc.addEventListener(VideoPlayerEvent.RESUME, onResume);
			controls_mc.addEventListener(VideoPlayerEvent.REWIND, onRewind);
			controls_mc.addEventListener(MouseEvent.ROLL_OVER, fadeInControls);
			controls_mc.addEventListener(MouseEvent.ROLL_OUT, fadeOutControls);
			controls_mc.addEventListener(VideoPlayerProgressEvent.UPDATELOCATION, onScrub);
			
			controls_mc.addEventListener(VideoPlayerEvent.DRAG, onDrag);
			controls_mc.addEventListener(VideoPlayerEvent.STOPDRAG, onStopDrag);
			
			//create the storage rectangles
			backgroundCo = new Rectangle();
			videoCo = new Rectangle();
			
			//sets the initial coordinates.
			backgroundCo.x = background_mc.x;
			backgroundCo.y = background_mc.y;
			backgroundCo.width = background_mc.width;
			backgroundCo.height = background_mc.height;
			videoCo.x = video_mc.x;
			videoCo.y = video_mc.y;
			videoCo.width = video_mc.width;
			videoCo.height = video_mc.height;
			__oX = this.x;
			__oY = this.y;
			
			dragStatus = false;
			//sets mute to initially be false
			__mute = false;
			
		
			
		}
		
		//CONSTRUCTOR HELPER - allows for user customization
		public function populate(_width:Number = 0, _height:Number = 0, _url:String = ""):void {
			//set the url
			
			//trace("populate");
			__url = _url;
			//set the width and heights
			__vWidth = videoCo.width = _width;
			__vHeight = videoCo.height = _height;
			//sets the original location of the video player in its parent
			__oX = this.x;
			__oY = this.y;
			done = false;
			
			
			//trace("Play " + play_btn.x + " " + play_btn.y);
			
			//resize
			//resize();
			
			//trace("Play " + play_btn.x + " " + play_btn.y);
		}
		
		public function onReset():void {
			
			/*
			if (replay_btn.parent) {
				removeChild(replay_btn);
			}
			
			if (!play_btn.parent) {
				play_btn.alpha = 1;
				addChild(play_btn);
			}
			*/
			
			//controls_mc.progress_mc.updateProgress(0, 1000, 0, 10);
			ns.seek(0);	
			ns.pause();
		}
		
		
		
		//GETTERS
		
		//Gets what mode the player is in
		public function get mode():String {
			return __mode;	
		}
		//Gets the duration of the video
		public function get duration():Number {
			return __duration;
		}
		//Gets the URL of the video we're loading
		public function get url():String {
			return __url;	
		}
		//Gets the Height of the video
		public function get vHeight():Number {
			return __vHeight;	
		}
		//Gets the Width of the video
		public function get vWidth():Number {
			return __vWidth;	
		}
		//Gets the Original X
		public function get originalX():Number {
			return __oX;	
		}
		//Gets the Original Y
		public function get originalY():Number {
			return __oY;	
		}
		
		
		//SETTERS
		
		//Sets the mode to be either minimized or maximized
		public function set mode(_mode:String):void {
			__mode = _mode;	
			//resizes
			resize();
		}
		//Sets the URL
		public function set url(_url:String):void {
			__url = _url;	
		}
		//Sets the Height
		public function set vHeight(_vHeight:Number):void {
			__vHeight = _vHeight;	
		}
		//Sets the Width
		public function set vWidth(_vWidth:Number):void {
			__vWidth = _vWidth;	
		}
		//Sets the Original X (in case you move the player during the apps runtime)
		public function set originalX(_oX:Number):void {
			__oX = _oX;	
		}
		//Sets the Original Y (in case you move the player during the apps runtime)
		public function set originalY(_oY:Number):void {
			__oY = _oY;	
		}
		
		
		
		
		
		//FUNCTIONALITY
		
		
		//When clicking on the big play button
		public function onPlay(e:MouseEvent):void {
			
			trace("url from video player" + url);
			
			//make sure we have a URL
			if (url != null) {
				video_mc.clear();
				video_mc.visible = true;
				video_mc.alpha = 1;
				
				//ease it out
				//play_btn.alphaTo(0, 500, "ease", removeButton, play_btn);
				//stream from the url
				ns.play(url);
				
				//enable the pause and resume controls
				controls_mc.enablePauseResume();
				//check the progress of loading and playing
				TweenEnterFrame.addListener(checkProgress);
				
				//TRACKING
				//ExternalInterface.call("trackEvent", AssetManager.getInstance().currentSection + "/video_page/started");
			}
		}
		
		public function onReplay(e:MouseEvent):void {
			//replay_btn.alphaTo(0, 500, "ease", removeButton, replay_btn);
			ns.seek(0);
			ns.resume();
			TweenEnterFrame.addListener(checkProgress);
			
			//TRACKING
			//ExternalInterface.call("trackEvent", AssetManager.getInstance().currentSection + "/video_page/started");
		}
		
		private function removeButton(_btn:SimpleButton, ...rest):void {
			if (_btn.parent) {
				removeChild(_btn.display);
			}
		}
		
		//When pausing the movie
		public function onPause(e:VideoPlayerEvent):void {
			ns.pause();	
		}
		
		//When resuming the movie
		public function onResume(e:VideoPlayerEvent):void {
			//play_btn.alphaTo(0, 500, "ease", removeButton, play_btn);
			
			if (done == false) {
				ns.resume();	
			}
			else {
				done = false;
				ns.seek(0);
				ns.resume();
				TweenEnterFrame.addListener(checkProgress);
			}
		}
		
		//When rewinding the moving
		public function onRewind(e:VideoPlayerEvent):void {
			ns.seek(0);	
		}
		
		//When going full screen
		public function onFullScreen(e:VideoPlayerEvent):void {
			//if we're in min mode
			if (__mode == "MIN") {
				//go max
				__mode = "MAX";
				dispatchEvent(new Event("videofullscreen", true));
				//TRACKING
				//ExternalInterface.call("trackEvent", AssetManager.getInstance().currentSection + "/video_page/fullscreen");
			}
			//and vice versa
			else {
				__mode = "MIN";
				dispatchEvent(new Event("videonormalscreen", true));
				//TRACKING
				//ExternalInterface.call("trackEvent", AssetManager.getInstance().currentSection + "/video_page/minimize");
			}
			//resize
			resize();
		}
		
		public function startCheckMute():void {
			//hack to see if we've muted or not
			addEventListener(Event.ENTER_FRAME, checkMute);
		}
		
		public function stopCheckMute():void {
			//hack to see if we've muted or not
			removeEventListener(Event.ENTER_FRAME, checkMute);
		}
		
		//hack to see if we've muted or not
		private function checkMute(e:Event):void {
//			if (AssetManager.getInstance().soundmanager.isMuted) {
//				if (controls_mc.mute_btn.parent) {
//					__mute = true;
//					var trans:SoundTransform = new SoundTransform();
//					trans.volume = 0;
//					ns.soundTransform = trans;
//					controls_mc.removeChild(controls_mc.mute_btn);
//					controls_mc.addChild(controls_mc.mutedown_btn);
//				}
//			}
//			else {
//				if (controls_mc.mutedown_btn.parent) {
//					__mute = false;
//					var trans2:SoundTransform = new SoundTransform();
//					trans2.volume = 1;
//					ns.soundTransform = trans2;
//					controls_mc.removeChild(controls_mc.mutedown_btn);
//					controls_mc.addChild(controls_mc.mute_btn);
//				}	
			//}
		}
		
		//When muting
		public function onMute(e:VideoPlayerEvent):void {
			//toggle mute
			__mute = !__mute;
			//create a new sound transform
		    var trans:SoundTransform = new SoundTransform();
		    //based on the mute, set the volume accordingly
		    if (__mute == true) {
		   		trans.volume = 0;
		    }
		    else {
		    	trans.volume = 1;
		    }
		    //set the transform of the movie's audio channel
			ns.soundTransform = trans;
			
			dispatchEvent(new Event("videoPlayerMute", true));		
		}
		
		//When scrubing the scrub bar
		protected function onScrub(e:VideoPlayerProgressEvent):void {
			//go to that point in the movie
			ns.seek(e.percent*duration);
		}
		
		//When checking the progress
		protected function checkProgress(e:Event):void {
			
			//Get the total and loaded bytes
			var bt:uint = ns.bytesTotal;
			var bl:uint = ns.bytesLoaded;
			//update the progress on the controls
			controls_mc.updateProgress(bl, bt, ns.time, duration, __mode);
			
			//if loading is complete
			if (bl == bt) {
				dispatchEvent(new VideoPlayerEvent("loadingcomplete"));	
			}
			
		}
		
		private function onDrag(e:VideoPlayerEvent):void {
			dragStatus = true;	
		}
		
		private function onStopDrag(e:VideoPlayerEvent):void {
			dragStatus = false;	
		}
		
		//To destroy the player properly and remove all listeners
		override public function destroy():void {
			//closes the stream
			ns.close();
			video_mc.clear();
			video_mc.alpha = 0;
			video_mc.visible = false;
			super.destroy();
		}
		
		
		//SIZING
		
		//To resize the player
		protected function resize():void {
			var newPlayY:Number;
			var newPlayX:Number;
			//based on the mode
			if (__mode == "MIN") {
				
				stage.displayState = StageDisplayState.NORMAL;
				
				var frameOffsetHalf:Number = (background_mc.width - video_mc.width)/2;
				
				background_mc.visible = true;
				controls_mc.alpha = 1;
				//set the video first
				video_mc.width = videoCo.width;
				video_mc.height = videoCo.height;
				video_mc.x = videoCo.x;
				video_mc.y = videoCo.y;
				
				
				//move the player to it's original position
				this.x = __oX;
				this.y = __oY;
				
				
				//move the play button to center 
				//newPlayX = ((video_mc.width/2) - play_btn.width/2) + frameOffsetHalf;
				//newPlayY = ((video_mc.height/2) - play_btn.height/2) + frameOffsetHalf;
				//play_btn.x = newPlayX;
				//play_btn.y = newPlayY;
				//replay_btn.x = newPlayX;
				//replay_btn.y = newPlayY;
				
				//set the background size
				background_mc.x = backgroundCo.x;
				background_mc.y = backgroundCo.y;
				background_mc.width = backgroundCo.width;
				background_mc.height = backgroundCo.height;
				
				
				
				//set the controls location
				//controls_mc.x =0;
				//controls_mc.y = background_mc.height-50;
				//and tell it to resize itself
				//controls_mc.resize(backgroundCo.width, backgroundCo.width);
				controls_mc.alpha = 1;
				controls_mc.revertToMin();
				
				__vWidth = videoCo.width;
				__vHeight = videoCo.height;
				
				
				checkProgress(null);
			}
			//if the mode is Fullscreen
			else if (__mode == "MAX") {
				
				
				stage.displayState = StageDisplayState.FULL_SCREEN;
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, revertToMin);
   				
   				var frameOffset:Number = background_mc.width - video_mc.width;
   				
				
				
				
				//determine the scale difference
				var vScale:Number = Math.min(stage.stageWidth/video_mc.width, stage.stageHeight/video_mc.height);
				//calculate the new width and height
				var newWidth:int = Math.ceil(video_mc.width * vScale) + 1;
				var newHeight:int = Math.ceil(video_mc.height * vScale) + 1;
				//set the controls location
				controls_mc.x = 0;
				controls_mc.y = stage.stageHeight - controls_mc.background_mc.height;
				
				frameOffset *= vScale;
				trace("Controls Y " + controls_mc.y);
				//tell it to resize itself
				controls_mc.resize(stage.stageWidth + frameOffset, stage.stageWidth);
				
				//set the background size
				background_mc.x = 0;
				background_mc.y = 0;
				background_mc.width = stage.stageWidth + frameOffset;
				background_mc.height = stage.stageHeight + frameOffset;
				
				//updates the video to take up the entire stage while maintaining aspect ratio and centering itself
				video_mc.width = newWidth;
				video_mc.height = newHeight;
				video_mc.x = (stage.stageWidth - video_mc.width)/2;
				video_mc.y = (stage.stageHeight - video_mc.height)/2;
				
				//center the play button
				//newPlayX = (stage.stageWidth/2) - play_btn.width/2;
				//newPlayY = (stage.stageHeight/2) - play_btn.height/2;
				//play_btn.x = newPlayX;
				//play_btn.y = newPlayY;
				//replay_btn.x = newPlayX;
				//replay_btn.y = newPlayY;
				
				__vWidth = stage.stageWidth;
				__vHeight = stage.stageHeight;
				
				//set the location of the player
				this.x = 0;
				this.y = 0;
				
			}

		}
		
		private function revertToMin(e:FullScreenEvent):void {
			controls_mc.alpha = 1;
			controls_mc.revertToMin();
			dispatchEvent(new Event("videonormalscreen", true));
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, revertToMin);
			this.mode = "MIN";
		}
		
		
		//When we want to fade out the controls
		protected function fadeOutControls(...rest):void {
			//only in MAX mode
			if (__mode == "MAX") {
				//hide the controls
				controls_mc.hide();
			}	
		}
		
		//When we want to fade in the controls
		protected function fadeInControls(...rest):void {
			//only in MAX mode
			if (__mode == "MAX") {
				//show the controls
				controls_mc.show();
			}
		}
		
		
		
		
		
		
		
		//STATUS EVENT RESPONDERS
		
		//When we get the MetaData
		
		public function onMetaData( info:Object ):void {
			trace("META W " + info.width);
			trace("META H " + info.height);
	
			//set the duration
			__duration = info.duration;

		}
		
		//If there's an error in loading the video
		protected function onError(e:IOErrorEvent):void {
			//Doesn't need to do anything really but we'll trace the problem
			trace("IO ERROR " + e.text);
		}
		
		
		//When the net status changes
		protected function onNetStatus(e:NetStatusEvent):void {
			
			//Trace out the staus code
			trace(e.info.code);
			
			var code:String = e.info.code;
			//based on the code...
			switch(code) {
				
				case "NetStream.Play.Stop":
					if (dragStatus == false) {
						//No need to check the progress anymore
				    	TweenEnterFrame.removeListener( checkProgress );
					   	//Dispatch complete event.
					    dispatchEvent(new VideoPlayerEvent("playbackcomplete"));
					    //Show replay button
					    //addChild(replay_btn);
					    //ease it in
						//replay_btn.alphaTo(100, 500, "ease");
						//replay_btn.addEventListener(MouseEvent.CLICK, onReplay);
						//TRACKING
						//ExternalInterface.call("trackEvent", AssetManager.getInstance().currentSection + "/video_page/completed");
						done = true;
						controls_mc.pauseToPlay();
					}
				break;
				
				case "NetStream.Buffer.Empty":
					if (!buffering_mc.parent) {
						addChild(buffering_mc.display);
						buffering_mc.alphaTo(1,300, "ease");// show the indicator
					}
					ns.bufferTime = SMALL_BUFFER;
				break;
				
				case "NetStream.Buffer.Full":
					if (buffering_mc.parent) {
						removeChild(buffering_mc.display);
						buffering_mc.alphaTo(0,300, "ease");
					}
					ns.bufferTime = LARGE_BUFFER;
				break;
				
				case "NetStream.Buffer.Flush":
					//debug( "buffertime = " + ns.bufferTime + " " + ns.bufferLength );
				break;
					
				case "NetStream.Play.StreamNotFound":
					//do nothing for now
				break;
			}
		}
		
		
		
	}
}