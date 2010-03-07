package com.fuelindustries.controls
{
	/**
	 * A FormField is a extended version of the TextInput Component, 
	 * where it can have an error state if it's contents fail validation.
	 * 
	 */
	public class FormField extends TextInput
	{
		
		private var __error:Boolean;

		/**
		 * Indicates whether or not the contents are valid and displays the correct state.
		 * 
		 */
		public function get error():Boolean
		{
			return( __error );			
		}
		
		/** @private */
		public function set error( val:Boolean ):void
		{
			setError( val );		
		}
				
		public function FormField()
		{
			super();
		}
		
		/**
		 * If <code>error</code> is set to true then the FormField will jump to the frame labeled "error"
		 * Override this function if you want the display state of the error to function differently.
		 * 
		 * @param val A boolean value. true if you want to show the error state, false if you don't
		 */
		protected function setError( val:Boolean ):void
		{
			__error = val;
			if( val )
			{
				this.gotoAndStop( "error" );					
			}
			else
			{
				this.gotoAndStop( "default" );				
			}
		}
		
	}
}