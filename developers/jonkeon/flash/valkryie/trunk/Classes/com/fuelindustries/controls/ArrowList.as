package com.fuelindustries.controls 
{
	import com.fuelindustries.controls.buttons.SimpleButton;
	import com.fuelindustries.utils.NumberUtils;

	import flash.events.MouseEvent;

	/**
	 * @author julian
	 */
	public class ArrowList extends BaseList 
	{
		public var up_mc:SimpleButton;
		public var down_mc:SimpleButton;
		
		public function ArrowList(cellRenderer:Class = null)
		{
			super( cellRenderer );
		}

		override protected function completeConstruction():void
		{
			super.completeConstruction( );
			up_mc.addEventListener( MouseEvent.CLICK, upClicked );
			down_mc.addEventListener(MouseEvent.CLICK, downClicked );
		}
		
		private function downClicked(event:MouseEvent):void
		{
			scrollItems( 1 );
		}

		private function upClicked(event:MouseEvent):void
		{
			scrollItems( -1 );
		}
		
		private function scrollItems( direction:int ):void
		{
			var max:int = (__dataProvider.length - __rowCount);
			
			var tmp:int = Math.round( __startIndex + direction );
			var newIndex:int = NumberUtils.constrain( tmp, 0, max );
			
			if( newIndex != __startIndex  )
			{
				__startIndex = newIndex;
				invalidateList();
			}
		}
		
		override protected function invalidateList( startindex:int = 0 ):void
		{
			super.invalidateList( startindex );
			invalidateScroller();
		}
		
		
		/**
		 * Determines whether the scrollbar should be visible based on how many items are in the 
		 * dataProvider compared to the rowCount
		 * 
		 */
		protected function invalidateScroller():void
		{
			if( __rows.length >= __dataProvider.length )
			{
				up_mc.visible = false;
				down_mc.visible = false;		
			}	
			else
			{
				up_mc.visible = true;
				down_mc.visible = true;
			}

			
			if( __startIndex == 0 )
			{
				up_mc.enabled = false;
				down_mc.enabled = true;	
			}
			else if( __startIndex == ( __dataProvider.length - __rowCount ) )
			{
				down_mc.enabled = false;
				up_mc.enabled = true;	
			}
			else
			{
				up_mc.enabled = true;
				down_mc.enabled = true;	
			}
		}

		override protected function onRemoved():void
		{
			super.onRemoved( );
			
			up_mc.removeEventListener( MouseEvent.CLICK, upClicked );
			down_mc.removeEventListener(MouseEvent.CLICK, downClicked );
		}
	}
}
