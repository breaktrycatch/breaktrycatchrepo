package com.fuelindustries.controls.scrollers
{
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.FuelMouseEvent;
	import com.fuelindustries.events.ScrollEvent;
	import com.fuelindustries.utils.IntervalCall;
	import com.fuelindustries.utils.IntervalManager;
	import com.fuelindustries.utils.NumberUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * Dispatched when the scrollbar scrolls the content
	 *
	 * @eventType com.fuelindustries_assetproxy.events.ScrollEvent.SCROLL
	 * 
	 */
	[Event(name="scroll", type="com.fuelindustries.events.ScrollEvent")]
	
	/**
	 * The ScrollBar component provides the end user with a way to control the 
	 * portion of data that is displayed when there is too much data to 
	 * fit in the display area. The scroll bar consists of four parts: 
	 * two arrow buttons, a track, and a thumb. The position of the 
	 * thumb and display of the buttons depends on the current state of 
	 * the scroll bar.
	 */
	public class ScrollBar extends FuelUI
	{
		public var up_mc:SimpleButton;
		public var down_mc:SimpleButton;
		public var thumb_mc:ScrollThumb;
		public var track_mc:MovieClip;
			
		private var __scrollDirection:String;
		private var __btnInterval:int;
		private var __barInterval:int;
		private var __dragging:Boolean;
		private var __scrollToMouseTimeout:uint;
		
		/** @private */
		protected var minVal:int;
		/** @private */
		protected var maxVal:int;
		/** @private */
		protected var __percent:Number;
		/** @private */
		protected var __scrollJumpAmt:Number = DEFAULT_SCROLL_JUMP_AMT;
		
		
		private static const DEFAULT_SCROLL_JUMP_AMT : Number = .2;

		/**
		 * Determines whether the scrollbar is scrolling vertical or horizontal.
		 * 
		 * @default ScrollDirection.VERTICAL
		 * 
		 * @see ScrollDirection
		 * 
		 */
		public function set scrollDirection( val:String ):void
		{
			__scrollDirection = val;
			
			setScrollProperties();
		}
		
		public function get scrollDirection():String
		{
			return( __scrollDirection );	
		}
		
		/** 
		 * The position in percent of the thumb
		 * A value between 0 and 1
		 */
		public function set percent( num:Number ):void
		{
			setPercent( num );
		}
		
		public function get percent():Number
		{
			return( getPercent() );	
		}
		
		
		/** 
		 * The percentage to scroll the thumb each frame while the user
		 * has their the mouse pressed on the track. To mimic the operating system
		 * scrollbars, this value should correspond to one page (all visible cell renderers
		 * in a list for example). 
		 * A value between 0 and 1
		 */
		public function set scrollJumpAmount( num:Number ):void
		{
			__scrollJumpAmt = num;
		}

		public function get scrollJumpAmount():Number
		{
			return( __scrollJumpAmt );	
		}
		
		public function ScrollBar()
		{
			super();
		}

		override protected function completeConstruction() : void
		{
			__scrollDirection = ScrollDirection.VERTICAL;
			setScrollProperties();
			setButtonEvents();
			adjustScrollBars(0);
			
			super.completeConstruction( );
		}

		/** @private */
		protected function setScrollProperties():void
		{
			if( __scrollDirection == ScrollDirection.VERTICAL )
			{
				minVal = track_mc.y;
				maxVal = track_mc.y + track_mc.height - thumb_mc.height;
				
				if( thumb_mc.y < minVal ) thumb_mc.y = minVal;
				if( thumb_mc.y  > maxVal ) thumb_mc.y = maxVal;
			}
			else if( __scrollDirection == ScrollDirection.HORIZONTAL )
			{
				minVal = track_mc.x;
				maxVal = track_mc.x + track_mc.width - thumb_mc.width;
				if( thumb_mc.x < minVal ) thumb_mc.x = minVal;
				if( thumb_mc.x  > maxVal ) thumb_mc.x = maxVal;
			}
		}
		
		/** @private */
		protected function setButtonEvents():void
		{
			up_mc.addEventListener( MouseEvent.CLICK, arrowRelease, false, 0, true );
			down_mc.addEventListener( MouseEvent.CLICK, arrowRelease, false, 0, true);
			
			up_mc.addEventListener( FuelMouseEvent.PRESS, arrowPress, false, 0, true );
			down_mc.addEventListener( FuelMouseEvent.PRESS, arrowPress, false, 0, true );
			
			up_mc.addEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease, false, 0, true );
			down_mc.addEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease, false, 0, true );
			
			thumb_mc.addEventListener( FuelMouseEvent.PRESS, startDragging, false, 0, true );
			thumb_mc.addEventListener( MouseEvent.MOUSE_UP, stopDragging, false, 0, true );
			thumb_mc.addEventListener( FuelMouseEvent.RELEASE_OUTSIDE, stopDragging, false, 0, true );
			
			//track_mc.addEventListener( MouseEvent.CLICK, trackClick, false, 0, true );
			track_mc.addEventListener( MouseEvent.MOUSE_DOWN, trackDown, false, 0, true );
		}

		private function trackUp(event : MouseEvent) : void 
		{
			IntervalManager.clearTimeout(__scrollToMouseTimeout);
			removeEventListener( Event.ENTER_FRAME, scrollToMouseUpdate);
		}
	
		private function trackDown(event : MouseEvent) : void 
		{
			scrollToMouse();
			__scrollToMouseTimeout = IntervalManager.setTimeout(startScrollToMouseLoop, 400);
			stage.addEventListener( MouseEvent.MOUSE_UP, trackUp, false, 0, true );
			
		}
		private function startScrollToMouseLoop(intCall:IntervalCall = null) : void
		{
			addEventListener( Event.ENTER_FRAME, scrollToMouseUpdate);
		}

		private function scrollToMouseUpdate(event : Event) : void 
		{
			scrollToMouse();
		}

		private function scrollToMouse() : void
		{
			// this method should do a "page up" or "page down", skipping as many cell renderers as are visible
			// until it reaches the mouse cursor or the end of the track.
			
			var mouseVal:Number = ( __scrollDirection == ScrollDirection.VERTICAL ) ? mouseY : mouseX;
			var thumbOffset:Number = (__scrollDirection == ScrollDirection.VERTICAL ) ? (thumb_mc.height / 2) : (thumb_mc.width / 2);
			var thumbPosition:Number = (__scrollDirection == ScrollDirection.VERTICAL ) ? (thumb_mc.y) : (thumb_mc.x);
			var diff : Number = mouseVal - (thumbPosition + thumbOffset);
			
			//TODO: This should be going up by the percentage that correlates to a full page (the number of visible cell renderers / dataProvider size).
			var newPercent:Number = (diff < 0) ? percent - __scrollJumpAmt : percent + __scrollJumpAmt;
			var newPosition:Number = newPercent * ( maxVal - minVal ) + minVal;
			var newThumbCenter:Number = newPosition + thumbOffset;
			
			if(((diff > 0) && newThumbCenter > mouseVal) || ((diff < 0) && newThumbCenter < mouseVal))
			{
				trackUp(null);
			}
			
			setPercent(NumberUtils.constrain( newPercent, 0, 1));
			scrollIt( ScrollType.BAR, getPercent() );
		}

		/** @private */
		protected function arrowRelease( e:MouseEvent ):void
		{
			IntervalManager.clearInterval( __btnInterval );
		}
		
		/** @private */
		protected function arrowPress( e:FuelMouseEvent ):void
		{
			var btn:DisplayObject = e.target as DisplayObject;
			var dir:int = ( btn == up_mc.display ) ? -1 : 1;
			scrollIt( ScrollType.LINE, dir );
			IntervalManager.clearInterval( __btnInterval );
			__btnInterval = IntervalManager.setInterval( buttonScroll, 100, dir );
		}
		
		private function buttonScroll( dir:Number, intCall:IntervalCall = null ):void
		{
			scrollIt( ScrollType.LINE, dir );
		}
		
		/** @private */
		protected function startDragging( e:FuelMouseEvent ):void
		{
			__dragging = true;
			var rect:Rectangle = new Rectangle();
			stage.addEventListener( MouseEvent.MOUSE_UP, stopDragging, false, 0, true );
			switch( __scrollDirection )
			{
				case ScrollDirection.VERTICAL:
					rect.left = thumb_mc.x;
					rect.top = minVal;
					rect.right = thumb_mc.x;
					rect.bottom = maxVal;
					thumb_mc.startDrag( false, rect );
					break;
				case ScrollDirection.HORIZONTAL:
					rect.left = minVal;
					rect.top = thumb_mc.y;
					rect.right = maxVal;
					rect.bottom = thumb_mc.y;
					thumb_mc.startDrag( false, rect );
					break;
			}
			
			IntervalManager.clearInterval( __barInterval );
			__barInterval = IntervalManager.setInterval( setPosition, 100 );
		}
		
		/** @private */
		protected function stopDragging( e:MouseEvent ):void
		{
			__dragging = false;
			thumb_mc.stopDrag();
			stage.removeEventListener( MouseEvent.MOUSE_UP, stopDragging, false ); 
			IntervalManager.clearInterval( __barInterval );
		}
		
		/** @private */
		protected function scrollIt( type:String, percent:Number ):void
		{
			dispatchEvent( new ScrollEvent( type, percent ) );
		}
		
		/** @private */
		protected function setPosition( intCall:IntervalCall = null ):void
		{
			__percent = getPercent();
			scrollIt( ScrollType.BAR, __percent );
		}
		
		/**
		 * Adujust the position of the scroll thumb based on a percentage
		 * 
		 * @param percent The percent, value between 0-1, of where the scroll thumb should go on the track
		 * 
		 */		
		public function adjustScrollBars( percent:Number ):void
		{
			var pos:Number;
			if( percent <= 0 )
			{
				pos = minVal;
			}
			else if( percent >= 1 )
			{
				pos = maxVal;
			}
			else
			{
				pos = ( percent )*( maxVal - minVal ) + minVal;
			}
			
			if( __scrollDirection == ScrollDirection.VERTICAL )
			{
				thumb_mc.y = pos;
			}
			else
			{
				thumb_mc.x = pos;
			}
			
		}
		
		private function setPercent( percent:Number ):void
		{
			var val:Number = percent * ( maxVal - minVal ) + minVal;
			if( __scrollDirection == ScrollDirection.VERTICAL )
			{
				thumb_mc.y = val;
			}
			else
			{
				thumb_mc.x = val;
			}
		}
		
		private function getPercent():Number
		{
			var val:Number = ( __scrollDirection == ScrollDirection.VERTICAL ) ? thumb_mc.y : thumb_mc.x;
			var percent:Number = Math.abs( ( val - minVal ) / ( maxVal - minVal ) );
			__percent = NumberUtils.constrain( percent, 0, 100 );
			return( __percent );
		}
		
		private function trackClick( e:MouseEvent ):void
		{
			if( __dragging ) return;
			
			var val:Number = ( __scrollDirection == ScrollDirection.VERTICAL ) ? e.localY: e.localX ;
			var dirOffset:Number = (__scrollDirection == ScrollDirection.VERTICAL ) ? (thumb_mc.height / 2) : (thumb_mc.width / 2);
			var newpos:Number = NumberUtils.constrain( ( val - dirOffset ), minVal, maxVal );
			
			if( __scrollDirection == ScrollDirection.VERTICAL )
			{
				thumb_mc.y = newpos;
			}
			else
			{
				thumb_mc.x = newpos;
			}
			
			scrollIt( ScrollType.BAR, getPercent() );
		}
		
		/**
		 * Hides the scrollbar
		 */
		public function hide():void
		{
			visible = false;	
		}
		
		/**
		 * Displays the scrollbar
		 */
		public function show():void
		{
			visible = true;	
		}

		override protected function onRemoved():void
		{
			super.onRemoved();
			up_mc.removeEventListener( MouseEvent.CLICK, arrowRelease );
			down_mc.removeEventListener( MouseEvent.CLICK, arrowRelease);
			
			up_mc.removeEventListener( FuelMouseEvent.PRESS, arrowPress );
			down_mc.removeEventListener( FuelMouseEvent.PRESS, arrowPress );
			
			up_mc.removeEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease );
			down_mc.removeEventListener( FuelMouseEvent.RELEASE_OUTSIDE, arrowRelease );
			
			thumb_mc.removeEventListener( FuelMouseEvent.PRESS, startDragging );
			thumb_mc.removeEventListener( MouseEvent.MOUSE_UP, stopDragging );
			thumb_mc.removeEventListener( FuelMouseEvent.RELEASE_OUTSIDE, stopDragging );
			
			track_mc.removeEventListener( MouseEvent.CLICK, trackClick );
		}
	}
}