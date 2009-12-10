package com.fuelindustries.controls
{
	import com.fuelindustries.core.FuelUI;

	import flash.events.*;
	import flash.text.TextField;

	/**
	 * The TextInput component is a single-line text component that
	 * contains a native ActionScript TextField object.
	 */
	public class TextInput extends FuelUI
	{
		
		public var label_txt:TextField;
		/** @private */
		protected var __editable:Boolean;
		/** @private */
		protected var __text:String;
		/** @private */
		protected var __password:Boolean;
		
		[Inspectable(defaultValue=0, category="Limits")]
		/**
		 * The maximum number of characters that the text field can contain, as entered by a user. 
		 * A script can insert more text than maxChars allows; 
		 * the maxChars property indicates only how much text a user can enter. 
		 * If the value of this property is 0, a user can enter an unlimited amount of text.
		 *  
		 * @default 0
		 * 
		*/
		public function get maxChars():int
	  	{
	    	return( label_txt.maxChars );
	  	}
	  	
	  	/** @private */
	  	public function set maxChars(w:int):void
	  	{
	    	label_txt.maxChars = w;
	  	}
		
		/**
		 * Sets the tabIndex of the TextInput
		 * 
		 */
		override public function get tabIndex():int 
		{
			return( label_txt.tabIndex );
		}
		
		/** @private */
		override public function set tabIndex( index:int ):void
		{
			label_txt.tabIndex = index;
		}

		
		[Inspectable(defaultValue=true)]
		/**
		 * Sets whether or not you can edit the TextInput.
		 * Acts like an enabled property.
		 * If set to true the TextField is set to Input, and if false set to Dynamic
		 * 
		 */
	  	public function get editable():Boolean
	  	{
	    	return __editable;
	  	}
	  	
	  	/** @private */
		public function set editable(w:Boolean):void
	  	{
	    	setEditable( w );
	  	}
	  	
					
		[Inspectable( type="String", defaultValue="" ) ]
		/**
		 * Indicates the set of characters that a user can enter into the text field. 
		 * If the value of the restrict property is null, you can enter any character.
		 * 
		 * @default null
		 * 
		 */
		public function get restrict():String
		{
			return( label_txt.restrict );
		}
		
		/** @private */
		public function set restrict( chars:String ):void
		{
			label_txt.restrict = ( chars == "" ) ? null : chars;
		}
		
		
				
		[Inspectable( type="String", defaultValue="" ) ]
		/**
		 * A string that is the current text in the text field. 
		 * Lines are separated by the carriage return character ('\r', ASCII 13). 
		 * This property contains unformatted text in the text field, without HTML tags. 
		 * 
		 */
		public function get text():String
		{
			return( label_txt.text );
		}
		
		/** @private */
		public function set text( txt:String ):void
		{
			setLabel( txt );
		}
		
		
		
		[Inspectable( type="Boolean", defaultValue="false" ) ]
		/**
		 * Specifies whether the text field is a password text field. 
		 * If the value of this property is true, 
		 * the text field is treated as a password text field and hides the input characters using 
		 * asterisks instead of the actual characters. 
		 * If false, the text field is not treated as a password text field. 
		 * When password mode is enabled, the Cut and Copy commands and their 
		 * corresponding keyboard shortcuts will not function. 
		 * This security mechanism prevents an unscrupulous user from using the shortcuts to 
		 * discover a password on an unattended computer. 
		 * 
		 * @default false
		 * 
		 */
		public function get password():Boolean
		{
			return( __password );
		}
		
		/** @private */
		public function set password( val:Boolean ):void
		{
			label_txt.displayAsPassword = val;
			__password = val;
		}

		/**
		 * The number of characters in a text field. A character such as tab (\t) counts as one character. 
		 * 
		 */
		public function get length():int
		{
			return( label_txt.text.length );
		}
		
		
		public function TextInput()
		{

		}

		override protected function completeConstruction():void
		{
			super.completeConstruction();
			initLabel();
		}

		/** private */
		protected function initLabel():void
		{
			tabChildren = true;
    		tabEnabled = false;
			addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
		}
		
		/** private */
		private function onFocusIn( e:FocusEvent ):void
		{
			if( e.target == this )
			{
				stage.focus = label_txt;
			}
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
			__text = txt;
			label_txt.text = __text;
		}
		
		/** private */
		protected function setEditable( s:Boolean ):void
		{
			__editable = s;
			label_txt.type = (s) ? "input" : "dynamic";
			label_txt.selectable = ( label_txt.type == "input" ) ? true : false;
		}

		override protected function onRemoved():void
		{
			super.onRemoved( );
			removeEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			destroy();
		}
	}
}