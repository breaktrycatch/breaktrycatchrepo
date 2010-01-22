package com.fuelindustries.tween.items 
{
	import com.fuelindustries.tween.interfaces.ITweenable;

	/**
	 * @author jdolce
	 */
	public class TweenPropertiesItem extends MotionItem 
	{
		
		private var __data:Object;
		private var __properties:Array;
		private var __mc:ITweenable;
		
		public function get mc():ITweenable
		{
			return( __mc );	
		}
		
		public function TweenPropertiesItem( mc:ITweenable, data:Object, duration:int, ease:String, callback:Function, callbackArgs:Array ):void
		{
			super( duration, ease, callback, callbackArgs );
			__data = data;
			
			__properties = [];
			
			for( var prop:String in __data )
			{
				var obj:Object = {};
				obj.property = prop;
				obj.end = __data[ prop ];
				obj.start = mc[ prop ];	
				
				__properties.push( obj );
			}
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
			
			for( var i:int = 0; i<__properties.length; i++ )
			{
				var item:Object = __properties[ i ];
				var startval:* = item.start;
				var endval:* =	item.end;
				var val:* = __easeFunction( timePassed/1000, startval, endval - startval, __duration/1000 );
				mc[ item.property ] = val;
			}

			
			__currenttime = currentTime;
			
			if( __currenttime >= __endtime ) 
			{
				completed = true;
				tweenComplete();
			}
			
			return( completed );
		}
		
		public override function tweenComplete():void
		{
			var diffTime:int = __currenttime - __endtime;
			for( var i:int = 0; i<__properties.length; i++ )
			{
				var item:Object = __properties[ i ];
				mc[ item.property ] = item.end;
			}
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}
