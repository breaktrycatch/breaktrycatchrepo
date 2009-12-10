package com.fuelindustries.tween
{
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.tween.items.AlphaItem;
	import com.fuelindustries.tween.items.BendItem;
	import com.fuelindustries.tween.items.BlurItem;
	import com.fuelindustries.tween.items.ColorItem;
	import com.fuelindustries.tween.items.FrameItem;
	import com.fuelindustries.tween.items.RotationItem;
	import com.fuelindustries.tween.items.ScaleItem;
	import com.fuelindustries.tween.items.SizeItem;
	import com.fuelindustries.tween.items.SlideItem;
	import com.fuelindustries.tween.items.TweenItem;
	import com.fuelindustries.tween.items.VolumeItem;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/** @private */
	public class MotionManager extends EventDispatcher
	{
		private static var __instance:MotionManager;
		private static var allowInstantiation:Boolean;
		
		private var __slideList:MotionList;
		private var __scaleList:MotionList;
		private var __alphaList:MotionList;
		private var __rotationList:MotionList;
		private var __sizeList:MotionList;
		private var __frameList:MotionList;
		private var __bendList:MotionList;
		private var __tweenList:MotionList;
		private var __volumeList:MotionList;
		private var __blurList:MotionList;
		private var __colorList:MotionList;
		
		private var __paused:Boolean;
		private var __timeDif:int;
		private var __timeLast:int;

		public static function getInstance():MotionManager
		{
			if( __instance == null )
			{
				allowInstantiation = true;
				__instance = new MotionManager();
				MovieClip.prototype.motionManager = __instance;
				__instance.initialize();
				allowInstantiation = false;
			}
			return( __instance );
		}
		
		/**
		* Toggles every tween currently being executed by the MotionManager. The first time you call pause() it will pause all of the tweens. The next time you call it will resume all of the tweens.
		*/
		public static function pause():void
		{
			__instance.__pause();
		}
		
		public function MotionManager():void
		{
			if( !allowInstantiation )
			{
				throw new Error( "MotionManager.allowInstantiation == false" );
			}
		}
		
		public function initialize():void
		{
			__slideList = new MotionList();
			__scaleList = new MotionList();
			__alphaList = new MotionList();
			__rotationList = new MotionList();
			__sizeList = new MotionList();
			__frameList = new MotionList();
			__bendList = new MotionList();
			__tweenList = new MotionList();
			__volumeList = new MotionList();
			__blurList = new MotionList();
			__colorList = new MotionList();
			
			
			TweenEnterFrame.addListener( onEnterFrame );
			__timeLast = getTimer();
			
		}
		
		public function frameTo( mc:AssetProxy, frame:*, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:FrameItem = new FrameItem( mc, frame, duration, type, callback, callbackArgs );
			__frameList.addItem( item );
		}
		
		public function tweenTo( mc:*, start:Array, end:Array, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:TweenItem = new TweenItem( mc, start, end, duration, type, callback, callbackArgs );
			__tweenList.addItem( item );
		}
		
		public function bendTo( mc:AssetProxy, cx:*, cy:*, ax:*, ay:*, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:BendItem = new BendItem( mc, cx, cy, ax, ay, duration, type, callback, callbackArgs );
			__bendList.addItem( item );
		}
		public function colorTo(mc:AssetProxy,color:*,duration:int,type:*=null,callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:ColorItem = new ColorItem(mc,color,duration,type,callback,callbackArgs);
			__colorList.addItem(item);
		}
		public function slideTo( mc:AssetProxy, x:*, y:*, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:SlideItem = new SlideItem( mc, x, y, duration, type, callback, callbackArgs );
			__slideList.addItem( item );
		}
		
		public function sizeTo( mc:AssetProxy, w:*, h:*, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:SizeItem = new SizeItem( mc, w, h, duration, type, callback, callbackArgs );
			__sizeList.addItem( item );
		}
		
		public function scaleTo( mc:AssetProxy, x:*, y:*, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:ScaleItem = new ScaleItem( mc, x, y, duration, type, callback, callbackArgs );
			__scaleList.addItem( item );
		}
		
		public function alphaTo( mc:AssetProxy, alpha:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:AlphaItem = new AlphaItem( mc, alpha, duration, type, callback, callbackArgs );
			__alphaList.addItem( item );
		}
		
		public function rotateTo( mc:AssetProxy, rotation:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:RotationItem = new RotationItem( mc, rotation, duration, type, callback, callbackArgs );
			__rotationList.addItem( item );
		}
		
		public function volumeTo( mc:*, vol:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:VolumeItem = new VolumeItem( mc, vol, duration, type, callback, callbackArgs );
			__volumeList.addItem( item );
		}
		
		public function blurTo( mc:AssetProxy, x:*, y:*, quality:int, duration:int, type:*=null, callback:Function=null, ...callbackArgs:Array ):void
		{
			var item:BlurItem = new BlurItem( mc, x, y, quality, duration, type, callback, callbackArgs );
			__blurList.addItem( item );
		}
		
		private function onEnterFrame( eventObj:Event ):void
		{
			var currTime:int = getTimer();
			__timeDif = currTime - __timeLast;
			if( __slideList.length > 0 ) __slide();
			if( __scaleList.length > 0 ) __scale();
			if( __alphaList.length > 0 ) __alpha();
			if( __rotationList.length > 0 ) __rotate();
			if( __sizeList.length > 0 ) __size();
			if( __frameList.length > 0 ) __frame();
			if( __bendList.length > 0 ) __bend();
			if( __tweenList.length > 0 ) __tween();
			if( __volumeList.length > 0 ) __volume();
			if( __blurList.length > 0 ) __blur();
            if(__colorList.length>0)__color();
			__timeLast = currTime;
		}
		
		private function __slide():void
		{
			var items:Dictionary = __slideList.items;
			for( var mc:Object in items )
			{
				var item:SlideItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__slideList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __color():void
		{
			var items:Dictionary = __colorList.items;
			for( var mc:Object in items )
			{
				var item:ColorItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__colorList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __scale():void
		{
			var items:Dictionary = __scaleList.items;
			for( var mc:Object in items )
			{
				var item:ScaleItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__scaleList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __alpha():void
		{
			var items:Dictionary = __alphaList.items;		
			
			for( var mc:Object in items )
			{
				var item:AlphaItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__alphaList.removeItem( mc as AssetProxy );
					item.executeCallback();
					
				}
			}
		}
		
		private function __rotate():void
		{
			var items:Dictionary = __rotationList.items;
			for( var mc:Object in items )
			{
				var item:RotationItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__rotationList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __size():void
		{
			var items:Dictionary = __sizeList.items;
			for( var mc:Object in items )
			{
				var item:SizeItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__sizeList.removeItem( mc as AssetProxy );
					item.executeCallback();					
				}
			}
		}
		
		private function __frame():void
		{
			var items:Dictionary = __frameList.items;
			for( var mc:Object in items )
			{
				var item:FrameItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__frameList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __bend():void
		{
			var items:Dictionary = __bendList.items;
			for( var mc:Object in items )
			{
				var item:BendItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__bendList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __tween():void
		{
			var items:Dictionary = __tweenList.items;
			for( var mc:Object in items )
			{
				var item:TweenItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__tweenList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
		
		private function __volume():void
		{
			var items:Dictionary = __volumeList.items;
			for( var mc:Object in items )
			{
				var item:VolumeItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__volumeList.removeItem( mc );
					item.executeCallback();
				}
			}
		}
		
		private function __blur():void
		{
			var items:Dictionary = __blurList.items;
			for( var mc:Object in items )
			{
				var item:BlurItem = items[ mc ];
				var completed:Boolean = item.update( __timeDif );
				if( completed )
				{
					__blurList.removeItem( mc as AssetProxy );
					item.executeCallback();
				}
			}
		}
					
		public function cancelTween( mc:*, type:String = "all" ):void
		{
			switch( type )
			{
				case "frameTo":
					__frameList.removeItem( mc );
					break;
				case "slideTo":
					__slideList.removeItem( mc );
					break;
				case "scaleTo":
					__scaleList.removeItem( mc );
					break;
				case "alphaTo":
					__alphaList.removeItem( mc );
					break;
				case "sizeTo":
					__sizeList.removeItem( mc );
					break;
				case "rotateTo":
					__rotationList.removeItem( mc );
					break;
				case "bendTo":
					__bendList.removeItem( mc );
					break;
				case "tweenTo":
					__tweenList.removeItem( mc );
					break;
				case "volumeTo":
					__volumeList.removeItem( mc );
					break;
				case "blurTo":
					__blurList.removeItem( mc );
					break;
					
				case "colorTo":
					__colorList.removeItem(mc);
					break;
				case "all":
					__bendList.removeItem( mc );
					__tweenList.removeItem( mc );
					__frameList.removeItem( mc );
					__slideList.removeItem( mc );
					__scaleList.removeItem( mc );
					__alphaList.removeItem( mc );
					__sizeList.removeItem( mc );
					__rotationList.removeItem( mc );
					__volumeList.removeItem( mc );
					__blurList.removeItem( mc );
					__colorList.removeItem(mc);
					break;
			}
		}
		
		public function pauseTween( mc:*, type:String = "all" ):void
		{
			switch( type )
			{
				case "frameTo":
					__frameList.pauseItem( mc );
					break;
				case "slideTo":
					__slideList.pauseItem( mc );
					break;
				case "scaleTo":
					__scaleList.pauseItem( mc );
					break;
				case "alphaTo":
					__alphaList.pauseItem( mc );
					break;
				case "sizeTo":
					__sizeList.pauseItem( mc );
					break;
				case "rotateTo":
					__rotationList.pauseItem( mc );
					break;
				case "bendTo":
					__bendList.pauseItem( mc );
					break;
				case "tweenTo":
					__tweenList.pauseItem( mc );
					break;
				case "volumeTo":
					__volumeList.pauseItem( mc );
					break;
				case "blurTo":
					__blurList.pauseItem( mc );
					break;
				case "colorTo":
					__colorList.pauseItem(mc);
					break;
				case "all":
					__tweenList.pauseItem( mc );
					__bendList.pauseItem( mc );
					__frameList.pauseItem( mc );
					__slideList.pauseItem( mc );
					__scaleList.pauseItem( mc );
					__alphaList.pauseItem( mc );
					__sizeList.pauseItem( mc );
					__rotationList.pauseItem( mc );
					__volumeList.pauseItem( mc );
					__blurList.pauseItem( mc );
					__colorList.pauseItem(mc);
					__tweenList.pauseItem( mc );
					
					break;
			}
		}
		
		public function resumeTween( mc:*, type:String = "all" ):void
		{
			switch( type )
			{
				case "frameTo":
					__frameList.resumeItem( mc );
					break;
				case "slideTo":
					__slideList.resumeItem( mc );
					break;
				case "scaleTo":
					__scaleList.resumeItem( mc );
					break;
				case "alphaTo":
					__alphaList.resumeItem( mc );
					break;
				case "sizeTo":
					__sizeList.resumeItem( mc );
					break;
				case "rotateTo":
					__rotationList.resumeItem( mc );
					break;
				case "bendTo":
					__bendList.resumeItem( mc );
					break;
				case "tweenTo":
					__tweenList.resumeItem( mc );
					break;
				case "volumeTo":
					__volumeList.resumeItem( mc );
					break;
				case "blurTo":
					__blurList.resumeItem( mc );
					break;
					
				case "colorTo":
					__colorList.resumeItem(mc);
					break;
				case "all":
					__tweenList.resumeItem( mc );
					__bendList.resumeItem( mc );
					__frameList.resumeItem( mc );
					__slideList.resumeItem( mc );
					__scaleList.resumeItem( mc );
					__alphaList.resumeItem( mc );
					__sizeList.resumeItem( mc );
					__rotationList.resumeItem( mc );
					__volumeList.resumeItem( mc );
					__blurList.resumeItem( mc );
					__tweenList.resumeItem( mc );
					__colorList.resumeItem(mc);
					break;
			}
		}
		
		private function __pause():void
		{
			__tweenList.pause( __paused );
			__bendList.pause( __paused );
			__frameList.pause( __paused );
			__slideList.pause( __paused );
			__scaleList.pause( __paused );
			__alphaList.pause( __paused );
			__sizeList.pause( __paused );
			__rotationList.pause( __paused );
			__volumeList.pause( __paused );
			__colorList.pause(__paused);
			__blurList.pause(__paused);
			
			__paused = !__paused;
			
		}
	}
}