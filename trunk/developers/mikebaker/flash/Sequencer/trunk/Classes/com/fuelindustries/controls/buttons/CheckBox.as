package com.fuelindustries.controls.buttons
{

	/**
	 * A very simple CheckBox class where the toggle value is set to true by default
	 */
	public class CheckBox extends SimpleButton
	{
		public function CheckBox()
		{
			super();
		}

		override protected function completeConstruction() : void
		{
			super.completeConstruction();
			toggle = true;
		}

		override protected function over() : void
		{
			//super.over();
		}
	}
}