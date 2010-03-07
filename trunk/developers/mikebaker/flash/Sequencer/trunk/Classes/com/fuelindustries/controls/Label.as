package com.fuelindustries.controls 
{	import com.fuelindustries.core.FuelUI;

	import flash.geom.ColorTransform;
	import flash.text.TextField;

	/**	 * @author jdolce
	 * This is a simple container for a dynamic textfield
	 * You can use the Label class when you need to put a textfield in a MovieClip in order to animate it.
	 * This way you can encapsulate the setting of the TextField	 */	public class Label extends FuelUI 
	{		private var __text:String;
		private var __textColor:uint;
		
		public var label_txt:TextField;
		
		public function set textColor( hex:uint ):void
		{
			setTextColor( hex );
		}
		
		public function get textColor():uint
		{
			return( __textColor );	
		}
		
		/**
		 * Sets the text of the label
		 * 
		 * @param txt The string to set the label to
		 */
		public function get text():String
		{
			return( label_txt.text );
		}
		
		/** private */
		public function set text( txt:String ):void
		{
			setLabel( txt );
		}
		
		public function set htmlText( txt:String ):void
		{
			setHTMLText( txt );
		}
		
		public function get htmlText():String
		{
			return( __text );	
		}
		
		public function get textWidth():Number
		{
			return( label_txt.textWidth );	
		}
	
		public function get textHeight():Number
		{
			return( label_txt.textHeight );	
		}
	
		/**
		 * Gets the length of the string
		 * 
		 */
		public function get length():int
		{
			return( label_txt.text.length );
		}
	
		public function Label()
		{			super();		}
		
		/**
		 * This is an internal method that actually sets the text for the label
		 * Override this method if you need to modify the label once the it has be set.
		 */
		protected function setLabel( txt:String ):void
		{
			__text = txt;
			label_txt.text = __text;
		}
		
		/**
		 * This sets a ColorTransform object with the supplied hex value to the label_txt TextField
		 * @param hex The hex value for the label_txt TextField
		 */
		protected function setTextColor( hex:uint ):void
		{
			var trans:ColorTransform = new ColorTransform();
			trans.color = hex;
			label_txt.transform.colorTransform = trans;	
		}
		
		protected function setHTMLText( txt:String ):void
		{
			__text = txt;
			label_txt.htmlText = txt;	
		}
		
		public function verticallyCenter( h:int ):void
		{
			label_txt.height = label_txt.textHeight + 5;
			label_txt.y = Math.round( ( h/2 ) - ( label_txt.height / 2 ) );				
		}
	}}