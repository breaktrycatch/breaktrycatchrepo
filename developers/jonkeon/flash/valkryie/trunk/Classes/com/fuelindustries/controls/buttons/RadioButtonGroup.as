package com.fuelindustries.controls.buttons
{
	import flash.events.EventDispatcher;

	/**
	 * The RadioButtonGroup class defines a group of RadioButton components 
	 * to act as a single component. When one radio button is selected, no other
	 * radio buttons from the same group can be selected.
	 *
     * @see RadioButton
     * @see RadioButton#group RadioButton.group
	 */
	public class RadioButtonGroup extends EventDispatcher
	{
		private static var __groups:Object;
		private static var groupCount:uint = 0;
		private static var __uniqueID:int = 0;
		
		/**
		 * Retrieves a reference to the specified radio button group.
		 * 
		 * @param name The name of the group for which to retrieve a reference.
		 * 
         * @return A reference to the specified RadioButtonGroup.
         * 
		 */
		public static function getGroup( name:String ):RadioButtonGroup
		{
			if( __groups == null ) __groups = {};
			var grp:RadioButtonGroup = __groups[ name ] as RadioButtonGroup;
			if( grp == null )
			{
				grp = new RadioButtonGroup( name );
				__groups[ name ] = grp;
				if( ( ++groupCount ) %20 == 0 ) 
				{
					cleanUpGroups();
				}	
			}
			return( grp );
		}
		
		public static function getUniqueID():int
		{
			return( __uniqueID++ );	
		}
		
		private static function cleanUpGroups():void 
		{
			for( var n:String in __groups ) 
			{
				var group:RadioButtonGroup = __groups[ n ] as RadioButtonGroup;
				if( group.length == 0 ) 
				{
					delete( __groups[ n ] );
				}
			}
		}

		private var __name:String;
		private var __radiobuttons:Array;
		private var __selection:RadioButton;
		
		/**
		 * Manually sets the selection of the group to the specificed RadioButton
		 * 
		 * @param btn The RadioButton to be selected
		 */
		public function get selection():RadioButton
		{
			return( __selection );	
		}
		
		/** private */
		public function set selection( btn:RadioButton ):void
		{
			setSelection( btn );	
		}
		
		/**
		 * The number of RadioButtons in the group
		 */
		public function get length():int
		{
			return( __radiobuttons.length );
		}
		
		public function RadioButtonGroup( name:String )
		{
			__name = name;
			__radiobuttons = [];
		}
		
		/**
		 * Adds a radio button to the internal radio button array for use with 
		 * radio button group indexing, which allows for the selection of a single radio button
		 * in a group of radio buttons.  This method is used automatically by radio buttons, 
		 * but can also be manually used to explicitly add a radio button to a group.
		 *
         * @param radioButton The RadioButton instance to be added to the current radio button group.
		 */
		public function addButton( btn:RadioButton ):void
		{
			var index:int = getIndex( btn );
			if( index == -1 )
			{
				__radiobuttons.push( btn );	
			}	
			else
			{
				__radiobuttons.splice( index, 1, btn );
				btn.groupname = __name;
			}
		}
		
		/**
		 * Clears the RadioButton instance from the internal list of radio buttons.
		 * 
         * @param radioButton The RadioButton instance to remove.
		 */
		public function removeButton( btn:RadioButton ):void
		{
			var index:int = getIndex( btn );
			__radiobuttons.splice( index, 1 );
			if( btn == __selection )
			{
				__selection = null;	
			}
			
		}
		
		public function removeAll() : void
		{
			__selection = null;
			__radiobuttons = [];
		}
		
		private function getIndex( btn:RadioButton ):int
		{
			for( var i:int = 0; i<__radiobuttons.length; i++ )
			{
				var rb:RadioButton = __radiobuttons[ i ] as RadioButton;
				if( btn == rb )
				{
					return( i );	
				}	
			}
			return( -1 );
		}
		
		private function setSelection( btn:RadioButton ):void
		{
			if( __selection != null )
			{
				if( __selection.selected )
				{
					__selection.selected = false;
				}
			}
			
			if( btn != null )
			{
				for( var i:int=0; i<__radiobuttons.length; i++ )
				{
					var mem:RadioButton = __radiobuttons[ i ] as RadioButton;
					if( mem.name == btn.name )
					{
						__selection = mem;
						return;
					}
				}
			}
			else
			{
				__selection = null;
			}
		}
	}
}