package com.fuelindustries.controls.buttons
{

	/**
	 * A combination of the RadioButton and EaseButton components
	 * @see RadioButton
	 * @see Easebutton
	 */	
	public class RadioEaseButton extends RadioButton
	{
		private var __duration:int;
		
		/**
		 * The duration in milliseconds of the animation
		 * 
		 * @param num The duration in milliseconds
		 * 
		 * @default 500
		 * 
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
		
		public function RadioEaseButton()
		{
			super();
			if( __duration == 0 )
			{
				__duration = 500;
			}
		}
		
		/** private */
		override protected function setFrame( frame:String ):void
		{
			switch( frame )
			{
				case "out":
				case "disabled":
					if( __selected )
						this.frameTo( 1, duration, "ease" );
					else
						this.frameTo( 0, duration, "ease" );
					break;
				case "over":
				case "down":
				case "selected":
					this.frameTo( 1, duration, "ease" );
					break;
			}

		}	
	}
}