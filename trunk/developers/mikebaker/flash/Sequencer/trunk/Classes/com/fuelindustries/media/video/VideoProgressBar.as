package com.fuelindustries.media.video 
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.VideoPlayerEvent;
	import com.fuelindustries.events.VideoPlayerProgressEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author sjohn
	 */
	public class VideoProgressBar extends FuelUI {
		
		
		public var background_mc:FuelUI;
		public var track_mc:FuelUI;
		public var thumb_mc:FuelUI;
		public var loadbar_mc:FuelUI;
		public var playbar_mc:FuelUI;
		public var highlight_mc:FuelUI;
		
		private var boundingRect:Rectangle;
		
		protected var thumbUpdate:Boolean;
		
		protected var trackDiff:Number;
		
		protected var originalTrackWidth:Number;
		
		protected var __mode:String;
		
		
		
		public function VideoProgressBar() {
			super();
			thumb_mc.buttonMode = true;
			thumb_mc.useHandCursor = true;
			thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, onThumbPress);
			track_mc.addEventListener(MouseEvent.MOUSE_DOWN, onTrackPress);
			thumbUpdate = true;
			trackDiff = background_mc.width - track_mc.width;
			boundingRect = new Rectangle(track_mc.x, thumb_mc.y, (track_mc.width - thumb_mc.width), 0);
			originalTrackWidth = track_mc.width;
			loadbar_mc.width = 0;
			playbar_mc.width = 0;
		}
		
		public function updateProgress(_bytesLoaded:int, _bytesTotal:int, _time:Number, _duration:Number):void {
			var load_per:Number = _bytesLoaded/_bytesTotal;
			var time_per:Number = _time/_duration;
			
			var load_width:Number = load_per*track_mc.width;
			var time_loc:Number = time_per*(track_mc.width - thumb_mc.width);
			var playbar_width:Number = time_per*track_mc.width;
			
			if (isNaN(time_loc)) {
				time_loc = 0;
			}
			
			loadbar_mc.width = load_width;
			if (thumbUpdate == true) {
				
				thumb_mc.x = time_loc + track_mc.x;
				playbar_mc.width = playbar_width;
			}
			
		}
		
		private function onTrackPress(e:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvent("drag"));
			stage.addEventListener(MouseEvent.MOUSE_UP, onTrackRelease);
			track_mc.addEventListener(MouseEvent.MOUSE_UP, onTrackRelease);
			addEventListener(Event.ENTER_FRAME, onTrackDragging);
		}
		
		private function onTrackRelease(e:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvent("stopdrag"));
			removeEventListener(Event.ENTER_FRAME, onTrackDragging);	
		}
		
		private function onTrackDragging(e:Event):void {
			//trace("Track Mouse X " + track_mc.mouseX);
			//trace("Track Width " + track_mc.width);
			var per:Number = track_mc.mouseX/originalTrackWidth;
			trace("PERCENTAGE DRAG " + per);
			if (per < 0) {
				per = 0;
			}
			
			else if (per > 1) {
				per = 1;
			}
			//thumb_mc.x = (per * (track_mc.width - thumb_mc.width)) + thumb_mc.width;
			dispatchEvent(new VideoPlayerProgressEvent("updatelocation", per));
		}
		
		private function onThumbPress(e:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvent("drag"));
			thumbUpdate = false;
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbRelease);
			thumb_mc.addEventListener(MouseEvent.MOUSE_UP, onThumbRelease);
			addEventListener(Event.ENTER_FRAME, onDragging);
			thumb_mc.startDrag(true, boundingRect);	
		}
		
		private function onThumbRelease(e:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvent("stopdrag"));
			removeEventListener(Event.ENTER_FRAME, onDragging);
			thumbUpdate = true;
			thumb_mc.stopDrag();	
		}
		
		private function onDragging(e:Event):void {
			var per:Number = (thumb_mc.x - track_mc.x)/(track_mc.width - thumb_mc.width);
			dispatchEvent(new VideoPlayerProgressEvent("updatelocation", per));
		}
		
		public function resize(_newWidth:Number):void {
			
			background_mc.width = _newWidth;
			track_mc.width = _newWidth - trackDiff;
			highlight_mc.width = track_mc.width;
			boundingRect = new Rectangle(track_mc.x, thumb_mc.y, (track_mc.width - thumb_mc.width), 0);
		}
	}
}
