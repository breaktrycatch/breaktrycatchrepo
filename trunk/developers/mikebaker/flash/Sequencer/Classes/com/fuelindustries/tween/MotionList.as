package com.fuelindustries.tween
{
	import com.fuelindustries.tween.interfaces.ITweenable;
	import com.fuelindustries.tween.items.MotionItem;

	import flash.utils.Dictionary;

	/** @private */
	public class MotionList extends Object
	{
		private var __length:int;
		private var __items:Dictionary;
		
		public function MotionList()
		{
			__length = 0;
			__items = new Dictionary( true );
		}
		
		public function addItem( mc:ITweenable, item:MotionItem ):void
		{
			if( __items[ mc ] == null )
			{
				__length++;
			}
			__items[ mc ] = item;

		}
		
		public function removeItem( mc:ITweenable ):void
		{
			var item:MotionItem = __items[ mc ];
			if( item != null )
			{
				delete( __items[ mc ] );
				__length--;
			}
		}
		
		public function pauseItem( mc:ITweenable ):void
		{
			var item:MotionItem = __items[ mc ];
			if( item != null )
			{
				item.pauseItem();
			}
		}
		
		public function resumeItem( mc:ITweenable ):void
		{
			var item:MotionItem = __items[ mc ];
			if( item != null )
			{
				item.resumeItem();
			}	
		}
		
		public function pause( paused:Boolean ):void
		{
			for( var each:Object in __items )
			{
				var item:MotionItem = __items[ each ];
				if( paused )
				{
					item.resumeItem();	
				}
				else
				{
					item.pauseItem();
				}
			}
		}
		
		public function get items():Dictionary
		{
			return( __items );
		}
		
		public function get length():int
		{
			return( __length );
		}
	}
}