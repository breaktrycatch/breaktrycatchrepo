package com.fuelindustries.controls.buttons 
{
	import com.fuelindustries.media.sound.SoundManager;

	/**
	 * @author jdolce
	 */
	public class AudioButton extends OnOffButton 
	{
		public function AudioButton()
		{
		}
		
		override protected function setState( state:Boolean ):void
		{
			super.setState( state );
			SoundManager.getInstance().mute( state );
		}
	}
}
