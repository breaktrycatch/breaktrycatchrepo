package com.humans.controls.buttons {
	import com.fuelindustries.controls.Label;
	import com.fuelindustries.controls.buttons.SimpleButton;

	/**
	 * @author jkeon
	 */
	public class LabelSimpleButton extends SimpleButton {
		
		public var label_mc:Label;
		
		public function LabelSimpleButton() {
			super();
		}
		
		public function get text():String {
			return label_mc.text;
		}
		public function set text( txt:String ):void
		{
			label_mc.text = txt;
		}
		
		
	}
}
