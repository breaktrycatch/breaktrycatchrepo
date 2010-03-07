package com.fuelindustries.tween.items
{
	import com.fuelindustries.tween.interfaces.IFrame;

	import flash.display.FrameLabel;

	/** @private */
	public class FrameItem extends MotionItem implements IMotionItem
	{
		private var __destFrame:int;
		private var __startFrame:Number;
		private var __mc:IFrame;
		
		public function get mc():IFrame
		{
			return( __mc );	
		}

		public function FrameItem( mc:IFrame, frame:*, duration:int, ease:String, callback:Function, callbackArgs:Array )
		{
			super( duration, ease, callback, callbackArgs );
			__mc = mc;
			__startFrame = mc.currentFrame;
			__destFrame = getDestFrame( frame );
		}
		
		private function getDestFrame( targetframe:* ):int
		{
			var frame:int = __startFrame;
			var type:String = ( typeof targetframe == "string" ) ? "label" : "frame";
			switch( type )
			{
				case "frame":
					if( targetframe <= 1 )
					{
						frame = Math.max( 1, Math.round( targetframe * __mc.totalFrames ) );
					}
					else
					{
						frame = targetframe;
					}
					break;
				case "label":
					var labels:Array = __mc.currentLabels;
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

			var frame:int = __easeFunction( timePassed/1000, __startFrame, __destFrame - __startFrame, __duration/1000 );
			__mc.gotoAndStop( frame );
			
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
			__mc.gotoAndStop( __destFrame );
			
			__timeDiff = diffTime;
			//executeCallback( diffTime );
		}
	}
}