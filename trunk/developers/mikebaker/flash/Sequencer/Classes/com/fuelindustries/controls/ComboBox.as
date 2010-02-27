package com.fuelindustries.controls 
{
	import com.fuelindustries.vo.ICellRendererData;
	import com.fuelindustries.controls.buttons.Button;
	import com.fuelindustries.controls.listClasses.SelectableCellRenderer;
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.events.ListEvent;

	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	/**
	 * Dispatched when a selection is made from the dropdown list
  	 * 
	 * @eventType flash.events.Event.CHANGE
	 * 
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
     * The ComboBox component contains a drop-down list from which the
     * user can select one value. Its functionality is similar to that 
     * of the SELECT form element in HTML.
     * @see com.fuelindustries_assetproxy.controls.List List
     * @see com.fuelindustries_assetproxy.controls.buttons.Button Button
     */
	public class ComboBox extends FuelUI
	{
		
		public var base_mc:Button;
		public var list_mc:SelectableList;
		
		/** @private */
		protected var __defaultLabel:String;
		/** @private */
		protected var __state:String;
		private var _mouseKillFocusAdded:Boolean = false;


		/**
		 * Sets the default label.
		 * For example, before an item is selected you can have the default label set to "Select an Item".
		 * This way you don't have to have the first item in the list say "Select an Item".
		 * If the default label isn't set then the first item in the <code>dataProvider</code> will be selected when set.
		 */
		public function set defaultLabel( str:String ):void
		{
			setDefaultLabel( str );	
		}
		
		public function get defaultLabel():String
		{
			return( __defaultLabel );	
		}
		
		/**
		 * @copy com.fuelindustries_assetproxy.controls.BaseList#dataProvider
		 * 
         * @see com.fuelindustries_assetproxy.data.DataProvider DataProvider
         * 
		 */
		public function set dataProvider( dp:Array ):void
		{
			setDataProvider( dp );	
		}
		
		public function get dataProvider():Array
		{
			return( list_mc.dataProvider );	
		}
		
		/**
		 * @copy com.fuelindustries_assetproxy.controls.SelectableList#selectedIndex
		 */
		public function set selectedIndex( num:int ):void
		{
			setSelectedIndex( num );	
		}

		public function get selectedIndex():int
		{
			return( list_mc.selectedIndex );	
		}
		
		/**
		 * @copy com.fuelindustries_assetproxy.controls.SelectableList#selectedItem
		 */
		public function get selectedItem():ICellRendererData
		{
			return( list_mc.selectedItem );	
		}

		public function ComboBox( cellRenderer:Class = null, list:Class = null )
		{
			super();
			
			setTypes( cellRenderer, list );
		}
		
		private function setTypes( cellRenderer:Class = null, list:Class = null ):void
		{
			if( cellRenderer == null ) cellRenderer = SelectableCellRenderer;
			if( list == null ) list = SelectableList;
			
			list_mc = new list( cellRenderer );
		}

		override protected function completeConstruction():void
		{
			super.completeConstruction( );
			init();
		}

		/** @private */
		private function init():void
		{
			__state = "closed";
			__enabled = true;
			base_mc.addEventListener( MouseEvent.CLICK, baseClick );
			var labels:Array = this.currentLabels;
			for( var i:int = 0; i<labels.length; i++ ) 
			{
				var label:FrameLabel = labels[ i ];
				if( label.name == "close" )
				{
					this.addFrameScript( label.frame - 2, openComplete );
				}
			}
			
			this.addFrameScript( totalFrames - 2, closeComplete );
			this.addFrameScript( 0, stop );
			list_mc.addEventListener( Event.CHANGE, listChange );
			list_mc.addEventListener( ListEvent.ITEM_CLICK, listSelection );
			
			this.addEventListener(FocusEvent.FOCUS_IN, onSetFocus );
			this.addEventListener(FocusEvent.FOCUS_OUT, onKillFocus );
			this.focusRect = false;
		}
		
		/** @private */
		private function onSetFocus( event:FocusEvent ):void
		{
			if( !__enabled ) return;
			if( __state == "closed")
			{
				open();	
			}
			
			if(!_mouseKillFocusAdded)
			{
				_mouseKillFocusAdded = true;
				stage.addEventListener(MouseEvent.CLICK, onMouseKillFocus);
			}
			
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		/** @private */
		private function onKeyDown( event:KeyboardEvent ):void
		{
			var index:int;
			
			switch( event.keyCode )
			{
				case Keyboard.UP:
					index = this.selectedIndex - 1;
					break;
				case Keyboard.DOWN:
					index = this.selectedIndex + 1;
					break;
				default:
					break;
			}
			
			if( index < this.dataProvider.length )
			{
				this.selectedIndex = index;	
			}
		}
		
		/** @private */
		private function onMouseKillFocus( event:MouseEvent ):void
		{
			//we are clicking on the list so don't close
			if( list_mc.hitTestPoint( event.stageX, event.stageY ) )
			{
				return;	
			}
			
			stage.removeEventListener(MouseEvent.CLICK, onMouseKillFocus );
			_mouseKillFocusAdded = false;
			
			if( __state == "open" || __state == "opening" )
			{
				close();	
			}
			
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		private function onKillFocus(event:FocusEvent):void
		{
			if(event.keyCode != 0)
			{
				onMouseKillFocus(new MouseEvent(MouseEvent.CLICK ) );
			}
		}
		
		/** @private */
		protected function closeComplete():void
		{
			__state = "closed";
			stop();
		}
		
		/** @private */
		protected function openComplete():void
		{
			__state = "open";
			stop();	
		}
		
		/** @private */
		protected function setDataProvider( dp:Array ):void
		{
			list_mc.dataProvider = dp;
			
			if( list_mc.selectedItem == null )
			{
				if( __defaultLabel != null )
				{
					setDefaultLabel( __defaultLabel );
				}
				else
				{
					list_mc.selectedIndex = 0;
					
					var firstitem:ICellRendererData = dp[ 0 ] as ICellRendererData;
					setLabel( firstitem.label );	
				}
			}
			else
			{
				setLabel( list_mc.selectedItem.label );	
			}
		}
		
		/** @private */
		private function checkState():void
		{
			
			if( __state == "open" )
			{
				close();	
			}
			else if( __state == "closed" )
			{
				open();	
			}
		}
		
		/** @private */
		private function open():void
		{
			__state = "opening";
			this.gotoAndPlay( "open" );
		}
		
		/** @private */
		private function close():void
		{
			__state = "closing";
			this.gotoAndPlay( "close" );
		}
		
		/** @private */
		private function baseClick( event:Event ):void
		{
			event.stopImmediatePropagation();
			checkState();
		}
		
		/** @private */
		protected function listChange( e:Event ):void
		{
			//called when the dataProvider has changed
		}
		
		/** @private */
		protected function listSelection( e:ListEvent ):void
		{
			setLabel( e.item.label );
			close();
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		/** @private */
		protected function setLabel( str:String ):void
		{
			base_mc.label = str;
		}
		
		/** @private */
		protected function setDefaultLabel( str:String ):void
		{
			__defaultLabel = str;
			
			if( list_mc.selectedItem == null )
			{
				base_mc.label = str;
			}
		}
		
		/** @private */
		protected function setSelectedIndex( num:int ):void
		{
			
			var item:ICellRendererData;
			
			
			if( num < 0 )
			{
				if( __defaultLabel != null )
				{
					num = -1;
					list_mc.selectedIndex = num;
					setDefaultLabel( __defaultLabel );
				}
				else
				{
					num = 0;
					item = list_mc.dataProvider[ 0 ] as ICellRendererData;
					setLabel( item.label );
					list_mc.selectedIndex = 0;	
				}
			}
			else
			{
				item = list_mc.dataProvider[ num ] as ICellRendererData;
				setLabel( item.label );
				list_mc.selectedIndex = num;
			}
		}
	}
}