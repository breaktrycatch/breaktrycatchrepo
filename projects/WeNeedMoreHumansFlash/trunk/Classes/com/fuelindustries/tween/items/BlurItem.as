package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.tween.interfaces.IFilter;

	import flash.filters.BlurFilter;

	/** @private */
	public class BlurItem extends MotionItem implements IMotionItem
	{
		private var __destx : *;
		private var __desty : *;
		private var __startx : int;
		private var __starty : int;
		private var __quality : int;
		private var __mc:IFilter;
		
		public function get mc():IFilter
		{
			return( __mc );	
		}
		
		public function BlurItem( mc : IFilter, ex :Number, ey :Number, quality : int, duration : int, ease : String, callback : Function, callbackArgs : Array )
		{
			super( duration, ease, callback, callbackArgs);
			__mc = mc;
			__destx = ( __destx == null || __destx == undefined ) ? ex : 0;
			__desty = ( __desty == null || __desty == undefined ) ? ey : 0;
			
			__startx = 0;
			__starty = 0;
			
			__quality = quality;
			
			var filters : Array = mc.filters;
			
			for( var i : int = 0;i < filters.length; i++ )
			{
				var filter : Object = filters[ i ];
				if( filter is BlurFilter )
				{
					var blur : BlurFilter = filter as BlurFilter;
					__startx = blur.blurX;
					__starty = blur.blurY;
				}	
			}
		}

		public override function update( motiontime : int ) : Boolean
		{
			var completed : Boolean = false;
			if( __paused ) return( completed );
			
			var currentTime : int = __currenttime + motiontime;
			var timePassed : int = __currenttime - __starttime;
			
			var filter : BlurFilter = new BlurFilter();
			filter.quality = __quality;
			
			var newx : int = __easeFunction(timePassed / 1000, __startx, __destx - __startx, __duration / 1000);
			filter.blurX = Math.round(newx);


			var newy : int = __easeFunction(timePassed / 1000, __starty, __desty - __starty, __duration / 1000);
			filter.blurY = Math.round(newy);

			addFilter(filter);
			
			__currenttime = currentTime;
			
			if( __currenttime >= __endtime ) 
			{
				
				completed = true;
				tweenComplete();
			}
			
			return( completed );
		}

		private function addFilter( filter : BlurFilter ) : void
		{
			var filters : Array = __mc.filters;
			var newfilters : Array = [];
			for( var i : int = 0;i < filters.length; i++ )
			{
				var currentFilter : Object = filters[ i ];
				if( !(currentFilter is BlurFilter) )
				{
					newfilters.push(currentFilter);	
				}
			}
			
			newfilters.push(filter);
			__mc.filters = newfilters;
		}

		public override function tweenComplete() : void
		{
			var diffTime : int = __currenttime - __endtime;
			var filter : BlurFilter = new BlurFilter(__destx, __desty, __quality);
			addFilter(filter);
			
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}