package com.fuelindustries.controls.buttons
{

	/**
	 * The RadioButton component lets you force a user to make a single
	 * selection from a set of choices. This component must be used in a
	 * group of at least two RadioButton instances. Only one member of
	 * the group can be selected at any given time. Selecting one radio
	 * button in a group deselects the currently selected radio button
	 * in the group. You set the <code>groupName</code> parameter to indicate which
	 * group a radio button belongs to.
	 *
	 * <p>A radio button can be enabled or disabled. A disabled radio button does not receive mouse or
	 * keyboard input.</p>
	 *
	 * @see RadioButtonGroup
	 */
	public class RadioButton extends Button
	{

		private var __groupname : String;
		private var __group : RadioButtonGroup;

		[Inspectable(defaultValue="groupname")]

		/**
		 * The group name for a radio button instance or group. You can use this property to get 
		 * or set a group name for a radio button instance or for a radio button group.
		 *
		 * @default "groupname"
		 */
		public function get groupname() : String
		{
			return( __groupname );	
		}

		/** private */
		public function set groupname( str : String ) : void
		{
			setGroup( str );
		}

		/**
		 * The RadioButtonGroup that the RadioButton belongs to
		 */
		public function get group() : RadioButtonGroup
		{
			return( __group );	
		}

		public function RadioButton()
		{
			super( );
		}

		override protected function completeConstruction() : void
		{
			__groupname = "FuelGroup";
			doubleClickEnabled = false;
			setGroup( __groupname );
			super.completeConstruction();
		}

		private function setGroup( name : String ) : void
		{
			if( __group != null )
			{
				__group.removeButton( this );	
			}
			__groupname = name;
			__group = RadioButtonGroup.getGroup( name );
			__group.addButton( this );
		}

		/** private */
		override protected function release() : void
		{
			var val : Boolean = ( __selected ) ? false : true;
			setSelected( val );
		}

		/** private */
		override protected function setSelected( val : Boolean ) : void
		{
			if( val == __selected ) return;
			super.setSelected( val );
			
			if( val )
			{
				if( __group.selection != this )
				{
					__group.selection = this;
					disableStates();
				}
			} 
			else 
			{
				enableStates();
				if( __group.selection == this )
				{
					__group.selection = null;	
				}
			}
		}
		
		override protected function setEnabled( val : Boolean ) : void
		{
			if( __selected ) return;			
			
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

		override protected function onRemoved() : void
		{
			__group.removeButton( this );
		}
	}
}