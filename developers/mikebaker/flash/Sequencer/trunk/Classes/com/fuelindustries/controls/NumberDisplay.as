package com.fuelindustries.controls
{
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.utils.IntervalManager;

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;

	/**
	 * Ported from the AS2 version of NumberDisplay.
	 * 
	 * You can now use comma separated numbers.
	 * To use, add an 11th frame to the charSkin_mc with a comma in it
	 * and set comma = true.
	 */
	public class NumberDisplay extends FuelUI 
	{
		// current number of the component.
		protected var __number 		: Number = 0; 
		
		// contains the number sprites.
		protected var __numbers 	: Array = new Array(); 
		protected var __spacing 	: Number = 1;
		protected var __zeroPadding : Number = 15;
		
		protected var __charSkin 	: String= "numberSkin_mc";
		protected var __prefix 		: Boolean = false;
		protected var __suffix 		: Boolean = false;
		protected var __useComma	: Boolean = true;
		protected var __paused 		: Boolean = false;
		
		/** @protected */
		protected var __displayInt 	: Number;
		/** @protected */
		protected var __remainingTime : Number = 0;
		/** @protected */
		protected var __destination : Number;
		/** @protected */
		protected var __callbackArray : Array;
		/** @protected */
		protected static const NO_CHARSKIN_ERROR : String = "The supplied charSkin could not be found";
		
		public function NumberDisplay()
		{
			super( );
		}
		
		/**
		 * Transitions the NumberDisplay to the supplied number in the supplied ammount of time.
		 * @param num The number for the display to transition to.
		 * @param time The ammount of time for the transition to last.
		 * @param args Arguments you wish to have applied to the callback function on display complete.
		 */
		public function displayTo( num : Number, time : Number, callback : Function = null, ...args ) : void
		{
			IntervalManager.clearInterval( __displayInt );
			
			__destination 	= num;
			__paused 		= false;
			__callbackArray = args;
			
			if( callback != null )
				__callbackArray.unshift( callback );
				
			__displayInt = IntervalManager.setInterval( countTo, 25, __number, num, getTimer( ), time, __callbackArray );
		}
		
		/**
		 * Sets the NumberDisplay to the supplied number immediately.
		 * @param num The number to display.
		 */
		public function updateDisplay( num : Number ) : void
		{
			if ( !isNaN( num ) )
			{
				__number = num = Math.floor( num );
				
				var n_arr : Array = [];
				
				do
				{
					n_arr.push( num % 10 );
					num = Math.floor( num / 10 );
				} while ( num > 0 );
				
				while ( n_arr.length < __zeroPadding )
				{
					n_arr.push( 0 );
				}
				
				if ( __prefix ) n_arr.push( "prefix" );
				if ( __suffix ) n_arr.unshift( "suffix" );
				
				clearNumbers( );
				
				var len : Number = n_arr.length;
				
				var commas : Array = new Array();
				
				for ( var i : Number = len; i > 0 ; i-- )
				{
					if( __useComma && i % 3 == 0 && ( len - i ) != 0 )
					{
						var comma : MovieClip = createChar();
						addChild( comma );
						
						// comma character goes on frame 11
						comma.gotoAndStop( 11 );
						
						comma.x = ( child.width + __spacing ) * ( len - i ) + commas.length * child.width;
						
						commas.push( commas );
						__numbers.push( comma );
					}
					
					var child : MovieClip = createChar();
					
					addChild( child );
					
					child.x = ( child.width + __spacing ) * ( len - i ) + commas.length * child.width;
					
					if ( isNaN( n_arr[ i - 1 ] ) )
					{
						child.gotoAndStop( n_arr[ i - 1 ] );
					}
					else
					{
						child.gotoAndStop( n_arr[ i - 1 ] + 1 );
					}
					
					__numbers.push( child );
				}
			}
		}
		
		override public function stop() : void
		{
			IntervalManager.clearInterval( __displayInt );	
		}
		
		/*
		 * Creates the characterSkin with error checking.
		 */
		protected function createChar() : MovieClip
		{
			// pulls the charSkin Class from the library and tries to instantiate
			var NumberSkin 	: Class;
			try
			{
				NumberSkin = getDefinitionByName( __charSkin ) as Class;
			}
			catch( e : Error )
			{
				throw new Error( NO_CHARSKIN_ERROR );
				return null;
			}
			
			return new NumberSkin( );
		}
		
		/*
		 * Triggered by displayTo on an interval. Calculates the appropriate number for
		 * the elapsed ammount of time and then calls display() to show it. Once the transition
		 * is complete, the interval is cleared and the callback is fired.
		 */
		protected function countTo( begin : Number, dest : Number, startTime : Number, dur : Number, ...args : Array ) : void
		{
			var time 	: Number = getTimer( );
			var elapsed : Number = time - startTime;
			var percent : Number = elapsed / dur;
			__remainingTime = dur - elapsed;
			var diff : Number = dest - begin;
			var num : Number;
			if ( dest > begin )
			{
				num = Math.min( begin + Math.round( diff * percent ), dest );
			}
			else
			{
				num = Math.max( begin + Math.round( diff * percent ), dest );
			}
			
			updateDisplay( num );
			
			if ( elapsed >= dur )
			{
				IntervalManager.clearInterval( __displayInt );
				
				// gets at the callback args 
				args = args[ 0 ];
				
				if ( args.length > 0 )
				{
					var func 	: Function = args[ 0 ];
					var fArgs 	: Array = args.slice( 1 );
					
					var overTime : Number = elapsed - dur;
					fArgs.push( overTime );
					
					func.call( null, fArgs );
				}
			}
		}
		
		/*
		 * Used to refresh the display. 
		 * Replaced calls to invalidate() with calls to draw().
		 */
		protected function draw() : void
		{
			updateDisplay( __number );
		}
		
		/*
		 * Clears the NumberDisplay completely.
		 */
		protected function clearNumbers() : void
		{
			if( __numbers.length )
			{
				do
				{
					var child : MovieClip = __numbers.shift( );
					
					if( child.parent )
					{
						removeChild( child );
					}
						
				} while( __numbers.length );
			}
			
			__numbers = new Array();
		}

		
		protected function setNumber( num : Number ) : void
		{
			if ( !isNaN( num ) )
			{
				__number = num;
				
				draw( );
			}
		}

		protected function setSpacing( s : Number ) : void
		{
			if ( !isNaN( s ) )
			{
				__spacing = s;
				
				draw( );
			}
		}

		protected function setPad( pad : Number ) : void
		{
			if ( !isNaN( pad ) )
			{
				__zeroPadding = Math.max( 0, pad );
				
				draw( );
			}
		}

		protected function setSkin( skin : String ) : void
		{
			if( skin != "" )
			{
				__charSkin = skin;
				
				draw( );
			}
		}

		protected function setPrefix( p : Boolean ) : void
		{
			__prefix = p;
			draw( );
		}

		protected function setSuffix( s : Boolean ) : void
		{
			__suffix = s;
			draw( );
		}
		
		protected function setComma( c : Boolean ) : void
		{
			__useComma = c;
			draw();	
		}
		
		[ Inspectable( type = "number", defaultValue = "0" ) ]

		public function set number( num : Number ) : void
		{
			setNumber( num );
		}

		public function get number() : Number
		{
			return ( __number );
		}
		[ Inspectable( type = "Number", defaultValue = "1" ) ]

		public function set spacing( s : Number ) : void
		{
			setSpacing( s );
		}

		public function get spacing() : Number
		{
			return ( __spacing );
		}
		[ Inspectable( type = "Number", defaultValue = "0" ) ]

		public function set zeroPadding( pad : Number ) : void
		{
			setPad( pad );
		}

		public function get zeroPadding() : Number
		{
			return ( __zeroPadding );
		}
		[ Inspectable( type = "String", defaultValue = "numberSkin_mc" ) ]

		public function set charSkin( skin : String ) : void
		{
			setSkin( skin );
		}

		public function get charSkin() : String
		{
			return ( __charSkin );
		}
		[ Inspectable( type = "Boolean", defaultValue = "false" ) ]

		public function set prefix( p : Boolean ) : void
		{
			setPrefix( p );
		}

		public function get prefix() : Boolean
		{
			return ( __prefix );
		}
		[ Inspectable( type = "Boolean", defaultValue = "false" ) ]

		public function set suffix( s : Boolean ) : void
		{
			setSuffix( s );
		}

		public function get suffix() : Boolean
		{
			return ( __suffix );
		}
		
		
		[ Inspectable( type = "Boolean", defaultValue = "false" ) ]
		public function set comma( s : Boolean ) : void
		{
			setComma( s );
		}

		public function get comma() : Boolean
		{
			return ( __useComma );
		}

		public function get paused() : Boolean
		{
			return ( __paused );
		}
	}
}
