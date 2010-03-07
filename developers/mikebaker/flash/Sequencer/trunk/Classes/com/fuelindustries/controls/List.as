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
		
		override protected function setDataProvider(dp : Array) : void {
			super.setDataProvider(dp);
			scrollbar_mc.scrollJumpAmount = this.rowCount/__dataProvider.length;
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
			var index:int;
			var adjust:Boolean = false;
			
			
			if( type == ScrollType.BAR )
			{
				index = Math.round( percent * max );
			}
			else if( type == ScrollType.LINE )
			{
				index = Math.round( __startIndex + percent );
				adjust = true;
			}

			
			newIndex = NumberUtils.constrain( index, 0, max );								
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
			scrollbar_mc.scrollJumpAmount = this.rowCount/__dataProvider.length;
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