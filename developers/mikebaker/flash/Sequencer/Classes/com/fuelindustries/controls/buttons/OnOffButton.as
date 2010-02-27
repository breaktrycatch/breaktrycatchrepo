package com.fuelindustries.controls.buttons 
{
	import com.fuelindustries.core.FuelUI;

	import flash.events.MouseEvent;

	/**
	 * @author jdolce
	 */
	public class OnOffButton extends FuelUI 
	{
		
		public var off_btn:SimpleButton;
		public var on_btn:SimpleButton;
		
		private var __state:Boolean;
		
		public function set state( state:Boolean ):void
		{
			setState( state );	
		}
		
		
		public function get state():Boolean
		{
			return( __state );	
		}
		
		
		public function OnOffButton()
		{
			super();
		}

		override protected function completeConstruction() : void
		{
			setState( false );
			super.completeConstruction( );
		}

		override protected function onAdded():void
		{
			super.onAdded();
			on_btn.addEventListener( MouseEvent.CLICK, onclick );
			off_btn.addEventListener( MouseEvent.CLICK, offclick );		
		}
		
		private function onclick( e:MouseEvent ):void
		{
			setState( false );	
		}
		
		private function offclick( e:MouseEvent ):void
		{
			setState( true );	
		}
		
		protected function setState( state:Boolean ):void
		{
			__state = state;
			
			if( __state )
			{
				on_btn.visible = true;
				off_btn.visible = false;	
			}
			else
			{
				on_btn.visible = false;
				off_btn.visible = true;
			}
		}
	}
}
