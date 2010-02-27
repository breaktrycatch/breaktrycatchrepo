package com.fuelindustries.controls.buttons
{
	import flash.text.TextField;

	/**
	 * The Button component represents a commonly used rectangular button. Similar to the SimpleButton component but has a label.
	 * There seems to be a bug or weird behaviour when trying to reset the label property across frames.
	 * It is recommended when creating buttons that you don't create key frames for the text field and only have one instance of it that spans across all frames.
	*/
	public class Button extends SimpleButton
	{
		
		public var label_txt:TextField;
		protected var __label:String;	
				
		/**
		 * Gets or sets the text label for the component.
		 * 
		 * @see #setLabel()
		 * 
		 */ 
		public function get label():String
		{
			return( __label );
		}
		
		/** @private */
		public function set label( txt:String ):void
		{
			setLabel( txt );
		}

		public function Button()
		{
			super();
		}
		
		/**
		 * Usually called from setting the label property this method sets the label_txt.text
		 * Override this function when extending this class to change the behaviour when setting the label.
		 * 
		 * @param txt The string to set the label too.
		 * 
		 * @ see label
		 * 
		 */
		protected function setLabel( txt:String ):void
		{
			if( txt == null ) txt = "";
			__label = txt;
			if( label_txt != null )
			{
				label_txt.text = txt;
			}
		}
		
	
		/** @private */
		override protected function draw():void
		{
			super.draw();
			setLabel( __label );
		}
		
		/** @private */
		override protected function setFrame( frame:String ):void
		{
			if( frame != this.currentLabel )
			{
				super.setFrame( frame );
			}
			
		}
		
	}
	
}