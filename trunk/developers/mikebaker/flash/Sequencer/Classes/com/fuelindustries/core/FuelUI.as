package com.fuelindustries.core
{
	import com.fuelindustries.debug.Log;
	import com.fuelindustries.tween.MotionManager;
	import com.fuelindustries.tween.interfaces.IAlpha;
	import com.fuelindustries.tween.interfaces.IFilter;
	import com.fuelindustries.tween.interfaces.IFrame;
	import com.fuelindustries.tween.interfaces.IPosition;
	import com.fuelindustries.tween.interfaces.IRotation;
	import com.fuelindustries.tween.interfaces.IScale;
	import com.fuelindustries.tween.interfaces.ISize;
	import com.fuelindustries.tween.interfaces.ITransform;
	import com.fuelindustries.tween.interfaces.ITween;
	import com.fuelindustries.tween.interfaces.IVolume;
	import com.fuelindustries.utils.IntervalManager;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	/**
	 * FuelUI is the base class for all MovieClips. 
	 * You should use this class instead of MovieClip.
	 */
	public class FuelUI extends AssetProxy implements IPosition, IAlpha, IVolume, ITransform, IFrame, IRotation, IScale, ISize, ITween, IFilter
	{
		/** @private */
		private var __mm : MotionManager;
		/** @private */
		protected var __enabled : Boolean;

		/**
		 * Sets the enabled state of the Object
		 * 
		 */
		override public function get enabled() : Boolean
		{
			return( __enabled );
		}

		/** @private */
		override public function set enabled( val : Boolean ) : void
		{
			setEnabled(val);
		}

		public function FuelUI()
		{
			super();
		}

		override protected function completeConstruction() : void
		{
			initMotionManager();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedEvent);
			
			super.completeConstruction();
		}

		/** @private */	
		private function onRemovedEvent( e : Event ) : void
		{
			stop();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedEvent);
			onRemoved();
		}

		/** @private */
		private function onAddedEvent( e : Event ) : void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedEvent);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedEvent);
			onAdded();
		}

		/**
		 * This method gets called when the DisplayObject when it's ADDED_TO_STAGE listener gets fired.
		 */
		protected function onAdded() : void
		{
		}

		/**
		 * This method gets called when the DisplayObject when it's REMOVED_FROM_STAGE listener gets fired.
		 */
		protected function onRemoved() : void
		{
		}

		/** @private */
		private function initMotionManager() : void
		{
			__mm = MotionManager.getInstance();
		}

		/**
		 * Override this method to affect the actual state of your component
		 * @param val Whether the component is enabled or disabled
		 */
		protected function setEnabled( val : Boolean ) : void
		{
			__enabled = val;	
		}

		/**
		 * Calls a method on the next frame
		 * @param func The name of the function to execute. 
		 * Do not include quotation marks or parentheses, and do not specify parameters of the function to call. 
		 * For example, use functionName, not functionName() or functionName(param). 
		 * @param callbackArgs An optional list of arguments that are passed to the closure function. 
		 */
		public function doLater( func : Function, ...callbackArgs : Array ) : void
		{
			callbackArgs.splice(0, 0, 1);
			callbackArgs.unshift(func);
			IntervalManager.skipFrames.apply(IntervalManager, callbackArgs);
		}

		/**
		 * Adds a MovieClip from the library to the display list.
		 * @param classname The name of the Class in the properties panel of the library item
		 * @return A reference to the added MovieClip
		 */
		public function attachMovie( classname : String, index : int = -1 ) : MovieClip
		{
			var classRef : Class = flash.utils.getDefinitionByName(classname) as Class;
			var instance : MovieClip = new classRef() as MovieClip;
			
			if( index == -1 )
			{
				addChild(instance);	
			}
			else
			{
				addChildAt(instance, index);	
			}

			return( instance );
		}

		/**
		 * Remove all the children from the clip
		 */
		public function removeAllChildren() : void
		{
			while( numChildren ) 
			{
				removeChildAt(0);
			}	
		}

		public function setToTop() : void
		{
			if( parent )
			{
				parent.addChildAt(display, parent.numChildren - 1);
			}	
		}

		/**
		 * Animates x and y position over time
		 * @param x The new x position of the object
		 * @param y The new y position of the object
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function slideTo( x : *, y : *, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(y);
			callbackArgs.unshift(x);
			callbackArgs.unshift(this);
			__mm.slideTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates a BlurFilter over time
		 * @param x The new blurX position of the object
		 * @param y The new blurY position of the object
		 * @param quality The quality of the BlurFilter
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function blurTo( x : *, y : *, quality : int, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(quality);
			callbackArgs.unshift(y);
			callbackArgs.unshift(x);
			callbackArgs.unshift(this);
			__mm.blurTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates Xscale and Yscale position over time
		 * @param x The new XScale position of the object
		 * @param y The new YScale position of the object
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function scaleTo( x : *, y : *, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array  ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(y);
			callbackArgs.unshift(x);
			callbackArgs.unshift(this);
			__mm.scaleTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates width and height position over time
		 * @param width The new width position of the object
		 * @param height The new height position of the object
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function sizeTo( width : *, height : *, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array  ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(height);
			callbackArgs.unshift(width);
			callbackArgs.unshift(this);
			__mm.sizeTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates alpha position over time
		 * @param alpha The new alpha value of the object
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function alphaTo( alpha : int, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array  ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(alpha);
			callbackArgs.unshift(this);
			__mm.alphaTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates rotation position over time
		 * @param degrees The new rotation value of the object
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function rotateTo( degrees : int, duration : int, type : * = null, callback : Function = null, ...callbackArgs : Array  ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(degrees);
			callbackArgs.unshift(this);
			__mm.rotateTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates the object on a curve over time
		 * @param cx The x value of the control point
		 * @param cy The y value of the control point
		 * @param ax The x value of the anchor point
		 * @param ay The y value of the anchor point
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function bendTo( cx : *, cy : *, ax : *, ay : *, duration : int, type : *=  null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(ay);
			callbackArgs.unshift(ax);
			callbackArgs.unshift(cy);
			callbackArgs.unshift(cx);
			callbackArgs.unshift(this);
			__mm.bendTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates a set of values from a start value to a end value. The new values are passed to a onTweenUpdate function.
		 * @param start The array of start values
		 * @param end The array of end values
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function tweenTo( start : Array, end : Array, duration : int, type : *=  null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(end);
			callbackArgs.unshift(start);
			callbackArgs.unshift(this);
			__mm.tweenTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Animates playhead over time
		 * @param frame The destination frame of the MovieClip. Can be frame number, frame label, or percent from 0-1.
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function frameTo( frame : *, duration : int, type : *=  null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(frame);
			callbackArgs.unshift(this);
			__mm.frameTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Fades the volume of the soundTransform
		 * @param Volume The destination volume of the MovieClip's SoundTransform propery. Valid values are 0-100
		 * @param duration The duration of the animation in milliseconds
		 * @param type Type of animation. Valid values are ( "ease", "elastic", "bounce" ) default is null
		 * @param callback The method to be called once the animation is complete
		 * @param callbackArgs Any arguments passed to the callback function
		 */
		public function volumeTo( volume : int, duration : int, type : *=  null, callback : Function = null, ...callbackArgs : Array ) : void
		{
			callbackArgs.unshift(callback);
			callbackArgs.unshift(type);
			callbackArgs.unshift(duration);
			callbackArgs.unshift(volume);
			callbackArgs.unshift(this);
			__mm.volumeTo.apply(__mm, callbackArgs); 
		}

		/**
		 * Cancel 1 or all tweens
		 * @param type The type of tween to cancel. Valid values are slideTo, alphaTo, rotateTo, frameTo, bendTo, scaleTo, sizeTo, tweenTo, all
		 * @default all
		 */
		public function cancelTween( type : String = "all" ) : void
		{
			__mm.cancelTween(this, type);	
		}

		/**
		 * pauses 1 or all tweens
		 * @param type The type of tween to pause. Valid values are slideTo, alphaTo, rotateTo, frameTo, bendTo, scaleTo, sizeTo, tweenTo, all
		 * @default all
		 */
		public function pauseTween( type : String = "all" ) : void
		{
			__mm.pauseTween(this, type);	
		}

		/**
		 * resumes 1 or all tweens
		 * @param type The type of tween to pause. Valid values are slideTo, alphaTo, rotateTo, frameTo, bendTo, scaleTo, sizeTo, tweenTo, all
		 * @default all
		 */
		public function resumeTween( type : String = "all" ) : void
		{
			__mm.resumeTween(this, type);	
		}

		/**
		 * This method gets called as a callback for the tweenTo command. You should override this method in your subclasses.
		 * @param args Callback arguments
		 */
		public function onTweenUpdate( ...args : Array ) : void
		{
			//override in your sub class
		}

		/**
		 * A wrapper function for Log.debug so the classes doesn't need to be imported in every class. 
		 * This works just like the trace function where you can specify an array to be used and it will 
		 * concat the message into 1 string for you.
		 * @param msg The message to debug
		 */
		public function debug( msg : Object, ...args : Array ) : void
		{
			var message : String = msg + " " + args.join(" ");
			Log.debug(message);	
		}

		/**
		 * A wrapper function for Log.debugObject so the classes doesn't need to be imported in every class 
		 * @param obj The object to debug
		 */
		public function debugObject( obj : Object ) : void
		{
			Log.debugObject(obj);	
		}

		/**
		 * A wrapper function for navigateToURL similar to getURL in AS2 
		 * @param url The url you want to open
		 * @param window The window you want the url to open in
		 * 
		 * valid values for the window parameter are
		 * <ul>"_self" specifies the current frame in the current window.</ul>
		 * <ul>"_blank" specifies a new window.</ul>
		 * <ul>"_parent" specifies the parent of the current frame.</ul>
		 * <ul>"_top" specifies the top-level frame in the current window.</ul>
		 * 
		 */
		public function getURL( url : String, window : String = null ) : void
		{
			var request : URLRequest = new URLRequest(url);
			navigateToURL(request, window);	
		}

		/**
		 * A wrapper function addEventListener where it changes the default value for useWeakReference to true
		 * @param msg The message to debug
		 */
		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);	
		}

		public function getFrameNumberForLabel( label:String ):int
		{
			for( var i:int = 0; i<currentLabels.length; i++ )
			{
				var frame:FrameLabel = currentLabels[ i ] as FrameLabel;
				if( frame.name == label )
				{
					return( frame.frame );	
				}	
			}	
			
			return -1;
		}
	}
}