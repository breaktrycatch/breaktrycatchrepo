package com.breaktrycatch.module_autoui 
{	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**	 * @author plemarquand	 */	public class AutoUIPanel extends Sprite 
	{	
		private var __isOpen : Boolean = true;
		private var __enableKey : uint = 32;
		private var __generator : AutoUIGenerator;

		public function AutoUIPanel()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAdded );		}

		public function create(target : *) : void
		{
			__generator = new AutoUIGenerator( target );
			__generator.generate( this );
		}

		public function observe(target : *) : void
		{
			__generator.addObserver( target );
		}

		private function onAdded(event : Event) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			stage.addEventListener( KeyboardEvent.KEY_UP, onHandleKey );
		}

		private function onHandleKey(event : KeyboardEvent) : void
		{
			if(event.keyCode == __enableKey)
			{
				__isOpen ? closePanel( ) : openPanel( );
				__isOpen = !__isOpen;
			}
		}

		private function openPanel() : void
		{
			visible = true;
		}

		private function closePanel() : void
		{
			visible = false;
		}
		
		public function set enableKey(key : uint) : void
		{
			__enableKey = key;
		}
	}}