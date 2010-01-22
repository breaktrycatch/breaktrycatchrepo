package com.fuelindustries.controls.scrollers
{
	import com.fuelindustries.events.ScrollEvent;

	import flash.events.*;
	import flash.text.TextField;

	/**
	 * Adds functionality to the Scrollbar class to handle scrolling content in a TextField
	 */
	public class TextScroller extends ScrollBar
	{
		
		private var __scrollTarget:TextField;
		
		/**
		 * The target TextField to scroll
		 * 
		 * @param txt The target TextField
		 * 
		 */
		public function set scrollTarget( txt:TextField ):void
		{
			setScrollTarget( txt );
		}
		
		public function get scrollTarget():TextField
		{
			return( __scrollTarget );	
		}
		
		
		public function TextScroller()
		{
			super();
		}

		override protected function completeConstruction():void
		{
			super.completeConstruction( );
			hide();
		}

		private function setScrollTarget( txt:TextField ):void
		{
			if( __scrollTarget != null ) 
			{
				__scrollTarget.removeEventListener( Event.CHANGE, handleTargetChange, false );
				__scrollTarget.removeEventListener( TextEvent.TEXT_INPUT, handleTargetChange, false );
				__scrollTarget.removeEventListener( Event.SCROLL, handleTargetScroll, false );
				removeEventListener( ScrollEvent.SCROLL, scrollTextField, false );
			}
			
			__scrollTarget = txt;
			
			if( __scrollTarget != null ) 
			{
				__scrollTarget.addEventListener( Event.CHANGE, handleTargetChange, false, 0, true );
				__scrollTarget.addEventListener( TextEvent.TEXT_INPUT, handleTargetChange, false, 0, true );
				__scrollTarget.addEventListener( Event.SCROLL, handleTargetScroll, false, 0, true );
				addEventListener( ScrollEvent.SCROLL, scrollTextField, false, 0, true );
				configureTarget();
			}
			else
			{
				hide();	
			}	
		}
		
		private function handleTargetChange( e:Event ):void
		{
			configureTarget();
		}
		
		private function configureTarget():void
		{
			if( __scrollTarget == null || __scrollTarget.text.length == 0 )
			{
				hide();
			}
			else
			{
				if(  __scrollTarget.height < __scrollTarget.textHeight )
				{
					show();
					adjustScrollBars( __scrollTarget.scrollV / __scrollTarget.maxScrollV );
				}
				else
				{
					hide();
				}
			}
		}
		
		private function handleTargetScroll( e:Event ):void
		{
			configureTarget();
		}
		
		private function scrollTextField( e:ScrollEvent ):void
		{
			var type:String = e.scrollType;
			var percent:Number = e.percent;
			
			switch( type )
			{
				case ScrollType.BAR:
					__scrollTarget.scrollV = Math.round( percent * __scrollTarget.maxScrollV );
					break;
				case ScrollType.LINE:
					__scrollTarget.scrollV = Math.round( __scrollTarget.scrollV + percent );
					adjustScrollBars( __scrollTarget.scrollV / __scrollTarget.maxScrollV );
					break;
			}
		}
		
		/**
		 * @inheritdoc
		 */
		override public function adjustScrollBars( percent:Number ):void
		{
			if( __scrollTarget != null )
			{
				
				if( __scrollTarget.scrollV == 1 )
					thumb_mc.y = minVal;
				else if( __scrollTarget.scrollV == __scrollTarget.maxScrollV )
					thumb_mc.y = maxVal;
				else
					thumb_mc.y = ( percent )*( maxVal - minVal ) + minVal;
			}
	
		}
		

	}
}