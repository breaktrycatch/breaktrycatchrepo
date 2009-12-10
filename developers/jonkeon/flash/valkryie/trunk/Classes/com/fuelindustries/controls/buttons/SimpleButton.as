package com.fuelindustries.controls.buttons
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.FuelMouseEvent;

	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.events.*;

	/**
	 * Dispatched when the left mouse button is clicked down on the button.
	 * 
	 *  @eventType ccom.fuelindustries_assetproxy.events.FuelMouseEvent.PRESS
	 *  
	 * */
	[Event(name="press", type="com.fuelindustries_assetproxy.events.FuelMouseEvent")]

	/**
	 * The BaseButton class is the base class for all button components, defining properties and methods that are common to all buttons. This class handles the dispatching of button events. 
	 */
	public class SimpleButton extends FuelUI
	{
		protected static const OVER : String = "over";
		protected static const OUT : String = "out";
		protected static const DOWN : String = "down";
		protected static const SELECTED : String = "selected";
		protected static const DISABLED : String = "disabled";
		
		/** @private */
		protected var __toggle : Boolean;
		/** @private */
		protected var __selected : Boolean;
		/** @private */
		protected var __data : Object;

		/**
		 * Gets or sets a Boolean value that indicates whether the button can be toggled.
		 * If the toggle property is set to true, when the button is clicked it will toggle the selected property.
		 */ 
		public function get toggle() : Boolean
		{
			return( __toggle );
		}

		/** @private */
		public function set toggle( val : Boolean ) : void
		{
			__toggle = val;
		}

		/**
		 * Gets or sets a Boolean value that indicates whether the button is selected.
		 * If the toggle property is set to false this property has no effect
		 */
		public function get selected() : Boolean
		{
			return( __selected );
		}

		/** @private */
		public function set selected( val : Boolean ) : void
		{
			setSelected( val );
		}

		/**
		 * Gets or sets a Object to the data property
		 */

		public function get data() : Object
		{
			return( __data );
		}

		/** @private */
		public function set data( val : Object ) : void
		{
			__data = val;
		}

		
		public function SimpleButton()
		{
			super( );
		}

		override protected function completeConstruction() : void
		{
			super.completeConstruction( );
			
			buttonMode = true;
			mouseChildren = false;
			__enabled = true;
			__selected = false;
			__toggle = false;
			setEnabled( __enabled );
			setSelected( __selected );
		}

		/** @private */
		protected function enableStates() : void
		{
			mouseEnabled = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, overEvent, false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT, outEvent, false, 0, true );
			addEventListener( MouseEvent.CLICK, releaseEvent, false, 0, true );
			addEventListener( MouseEvent.MOUSE_DOWN, pressEvent, false, 0, true );
		}

		/** @private */
		protected function disableStates() : void
		{
			mouseEnabled = false;
			removeEventListener( MouseEvent.MOUSE_OVER, overEvent );
			removeEventListener( MouseEvent.ROLL_OUT, outEvent );
			removeEventListener( MouseEvent.CLICK, releaseEvent );
			removeEventListener( MouseEvent.MOUSE_DOWN, pressEvent );
		}

		// SM added a select item for manual selection
		public function select() : void
		{
			// manual select
			press( );
		}

		/** @private */	
		private function overEvent( e : Event ) : void
		{
			over( );
		}

		/** @private */
		private function outEvent( e : Event ) : void
		{
			out( );
		}

		/** @private */
		private function releaseEvent( e : Event ) : void
		{
			release( );
		}

		/** @private */
		private function pressEvent( e : Event ) : void
		{
			press( );
			
			if( stage != null )
			{
				stage.addEventListener( MouseEvent.MOUSE_UP, stageMouseUp );	
			}
		}
		
		private function stageMouseUp(event:MouseEvent):void
		{
			
			if( stage != null )
			{
				stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouseUp );
			}
			
			
			 if (event.target == this || contains( event.target as DisplayObject))
			 {
				//relased inside
			 }
			 else
			 {
			 	//released outside
			 	dispatchEvent( new FuelMouseEvent( FuelMouseEvent.RELEASE_OUTSIDE ) );
			 	
			 	if( !__toggle && __enabled )
			 	{
			 		out();
			 	}
			 }
		}

		/** @private */
		override protected function setEnabled( val : Boolean ) : void
		{
			if( val )
			{
				enableStates();
				if( !__selected )
				{
					out( );
				}
				else
				{
					drawSelected( );
				}
			}
			else
			{
				disableStates( );
				setFrame( DISABLED );
			}
			mouseEnabled = val;
			super.setEnabled( val );
		}

		/** @private */
		protected function setSelected( val : Boolean ) : void
		{
			__selected = val;
			if( val )
			{
				drawSelected( );
			}
			else
			{
				if( __enabled )
				{
					drawDeselected( );
				}
			}
		}

		/** @private */
		protected function drawSelected() : void
		{
			setFrame( SELECTED );
		}

		/** @private */
		protected function drawDeselected() : void
		{
			setFrame( OUT );
		}

		/** @private */
		protected function over() : void
		{
			setFrame( OVER );
		}

		/** @private */
		protected function out() : void
		{
			if( __selected )
			{
				drawSelected( );
			}
			else
			{
				drawDeselected( );
			}
		}

		/** @private */
		protected function release() : void
		{
			if( !__toggle )
			{
				over();
			}
			else
			{
				var val : Boolean = ( __selected ) ? false : true;
				setSelected( val );
			}
		}

		/** @private */
		protected function press() : void
		{
			setFrame( DOWN );
			dispatchEvent( new FuelMouseEvent( FuelMouseEvent.PRESS ) );
		}

		/** @private */
		private function handleRender( e : Event ) : void
		{
			removeEventListener( Event.RENDER, handleRender );
			draw( );
		}

		/** @private */
		protected function draw() : void
		{
			//override this function to update data when changing frames	
		}

		/** @private */
		protected function setFrame( frame : String ) : void
		{
			if( this.currentLabel == null )
			{
				var val : Boolean = checkForLabel( frame );
				if( !val ) return;	
			}
			
			if( frame != this.currentLabel )
			{
				if( stage != null )
				{
					addEventListener( Event.RENDER, handleRender );
					stage.invalidate( );
				}
				this.gotoAndStop( frame );
			}
		}

		protected function checkForLabel( label : String ) : Boolean
		{
			var labels : Array = this.currentLabels;
			for( var i : int = 0; i < labels.length ; i++ )
			{
				var fl:FrameLabel = labels[ i ] as FrameLabel;
				
				if( fl.name == label )
				{
					return( true );	
				}	
			}
			return( false );
		}

		override public function destroy() : void {
			if( stage != null )
			{
				stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouseUp );	
			}
			removeEventListener( MouseEvent.MOUSE_OVER, overEvent );
			removeEventListener( MouseEvent.ROLL_OUT, outEvent );
			removeEventListener( MouseEvent.CLICK, releaseEvent );
			removeEventListener( MouseEvent.MOUSE_DOWN, pressEvent );
			removeEventListener( Event.RENDER, handleRender );
			__data = null;
			super.destroy();
		}
	}
}