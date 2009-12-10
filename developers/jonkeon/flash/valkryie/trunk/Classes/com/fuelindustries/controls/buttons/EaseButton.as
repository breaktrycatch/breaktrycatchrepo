package com.fuelindustries.controls.buttons
{
	/**
	 * A button that when rolled over plays through the timeline over a specified duration.
	 * When the user rolls out it plays the animation in reverse from the current spot in the playhead.
	 */
	public class EaseButton extends SimpleButton
	{
		private static var __defaultDuration:uint = 500;
		
		private var __duration:int;
		
		public static function set defaultDuration( num:uint ):void
		{
			__defaultDuration = num;	
		}
		
		public static function get defaultDuration():uint
		{
			return( __defaultDuration );	
		}
		
		/**
		 * The duration in milliseconds of the animation
		 * @param num The duration in milliseconds
		 * @default 500
		 */
		public function get duration():int
		{
			return( __duration );	
		}
		
		/** private */
		public function set duration( num:int ):void
		{
			__duration = num;	
		}

		
		public function EaseButton()
		{
			super();
			if( __duration == 0 ) 
				__duration = __defaultDuration;
		}
		
		/** private */
		override protected function setFrame( frame:String ):void
		{
			switch( frame )
			{
				case OUT:
				case DISABLED:
					this.frameTo( 0, __duration );
					break;
				case OVER:
				case DOWN:
				case SELECTED:
					this.frameTo( 1, __duration );
					break;
				
			}
		}

		override public function destroy() : void {
			this.cancelTween();
			super.destroy();
		}
	}
}