package com.fuelindustries.controls 
{
	import com.fuelindustries.controls.scrollers.ScrollBar;
	import com.fuelindustries.controls.scrollers.ScrollType;
	import com.fuelindustries.events.DataProviderEvent;
	import com.fuelindustries.events.ScrollEvent;
	import com.fuelindustries.utils.NumberUtils;

	public class List extends SelectableList
	{
		/** @private */
		public var scrollbar_mc:ScrollBar;
		
		public function List( cellRenderer:Class = null )
		{
			super( cellRenderer );
		}
		
		/** @private */
		override protected function init():void
		{
			super.init();
			scrollbar_mc.visible = false;
			scrollbar_mc.addEventListener( ScrollEvent.SCROLL, scrollChange );

		}
		
		/** @private */
		override protected function dataChange( event:DataProviderEvent ):void
		{
			super.dataChange( event );
			invalidateScroller();
			adjustScrollbar();
		}

		/** @inheritDoc */
		override protected function invalidateList( startIndex:int = 0 ):void
		{
			super.invalidateList( startIndex );
			invalidateScroller();
		}
		
		/**
		 * Determines whether the scrollbar should be visible based on how many 
		 * items are in the dataProvider compared to the rowCount.
		 * 
		 */
		protected function invalidateScroller():void
		{
			if( __rows.length >= __dataProvider.length )
			{
				scrollbar_mc.visible = false;	
			}	
			else
			{
				scrollbar_mc.visible = true;	
			}
		}
		
		/** @private */
		protected function scrollChange( event:ScrollEvent ):void
		{
			var type:String = event.scrollType;
			var percent:Number = event.percent;
			var max:int = (__dataProvider.length - __rowCount);
			var newIndex:int;
			var tmp:int;
			var adjust:Boolean = false;
			
			switch( type )
			{
				case ScrollType.BAR:
					tmp = Math.round( percent * max );
					break;
				case ScrollType.LINE:
					tmp = Math.round( __startIndex + percent );
					adjust = true;
					break;	
			}
			
			newIndex = NumberUtils.constrain( tmp, 0, max );								
			if( newIndex != __startIndex  )
			{
				__startIndex = newIndex;
				invalidateList();
				if( adjust )
				{
					adjustScrollbar();
				}
			}
		}
		
		/** @private */
		protected function adjustScrollbar():void
		{
			var max:int = (__dataProvider.length - __rowCount);
			var min:int = 0;
			
			if( __startIndex == min )
			{
				scrollbar_mc.adjustScrollBars( 0 );
			}
			else if( __startIndex == max )
			{
				scrollbar_mc.adjustScrollBars( 1 );
			}
			else
			{
				scrollbar_mc.adjustScrollBars( __startIndex / max );
			}
		}
		
		protected override function setSelectedIndex( index:int ):void
		{
			super.setSelectedIndex( index );
									
			if (__startIndex + index > __rowCount || __startIndex > index )
			{
				var max:int = (__dataProvider.length - __rowCount);
				var min:int = 0;
				
				__startIndex = NumberUtils.constrain( index, min, max);
								
				invalidateList();
				adjustScrollbar();
			}
		}
	}
}