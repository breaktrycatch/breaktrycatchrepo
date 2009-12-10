package com.fuelindustries.tween.items
{
	import com.fuelindustries.core.AssetProxy;

	import flash.display.FrameLabel;

	/** @private */
	public class FrameItem extends MotionItem implements IMotionItem
	{
		private var __destFrame:int;
		private var __startFrame:Number;

		public function FrameItem( mc:AssetProxy, frame:*, duration:int, ease:*, callback:Function, callbackArgs:Array )
		{
			super( mc, duration, ease, callback, callbackArgs );
			__startFrame = mc.currentFrame;
			__destFrame = getDestFrame( frame );
		}
		
		private function getDestFrame( targetframe:* ):int
		{
			var frame:int = __startFrame;
			var type:String = ( typeof targetframe == "string" ) ? "label" : "frame";
			var mc:AssetProxy = __mc as AssetProxy;
			switch( type )
			{
				case "frame":
					if( targetframe <= 1 )
					{
						frame = Math.max( 1, Math.round( targetframe * mc.totalFrames ) );
					}
					else
					{
						frame = targetframe;
					}
					break;
				case "label":
					var labels:Array = mc.currentLabels;
					for( var i:int = 0; i<labels.length; i++ ) 
					{
						var label:FrameLabel = labels[ i ];
						if( label.name == targetframe )
						{
							return( label.frame );
						}
					}
					break;
			}
			
			return( frame );
		}
		
		public override function update( motiontime:int ):Boolean
		{
			var completed:Boolean = false;
			if( __paused ) return( completed );
			var currentTime:int = __currenttime + motiontime;
			var timePassed:int = __currenttime - __starttime;
			var mc:AssetProxy = __mc as AssetProxy;
			var frame:int = __easeFunction( timePassed/1000, __startFrame, __destFrame - __startFrame, __duration/1000 );
			mc.gotoAndStop( frame );
			
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
			var mc:AssetProxy = __mc as AssetProxy;
			mc.gotoAndStop( __destFrame );
			
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}