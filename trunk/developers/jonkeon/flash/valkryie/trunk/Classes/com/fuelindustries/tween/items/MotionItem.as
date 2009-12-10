package com.fuelindustries.tween.items 
{
	import flash.utils.getTimer;

	/** @private */
	public class MotionItem extends Object implements IMotionItem 
	{
		internal var __starttime:int;
		internal var __endtime:int;
		internal var __currenttime:int;
		internal var __paused:Boolean;
		internal var __mc:Object;
		internal var __duration:int;
		internal var __pauseTime:int;
		internal var __callback:Function;
		internal var __callbackArgs:Array;
		internal var __easeFunction:Function;
		internal var __timeDiff:int;
		internal var __completed:Boolean;

		public function get mc():Object 
		{
			return( __mc );
		}

		public function get paused():Boolean 
		{
			return ( __paused );
		}

		public function MotionItem( mc:Object, duration:Number, type:*, callback:Function, callbackArgs:Array ) 
		{
			__duration = duration;
			__starttime = getTimer( );
			__endtime = __starttime + __duration;
			__currenttime = __starttime;
			__paused = false;
			__completed = false;
			
			__mc = mc;
			__callback = callback;
			__callbackArgs = callbackArgs;
			setEaseFunction( type );
		}

		private function setEaseFunction( type:* ):void 
		{
			if( typeof type == "function" ) 
			{
				__easeFunction = type;
			}
			else 
			{
				switch( type ) 
				{
					case "ease":
						__easeFunction = ease;
						break;
					case "elastic":
						__easeFunction = elastic;
						break;
					case "bounce":
						__easeFunction = bounce;
						break;
					case "linear":
					case "easenone":
						__easeFunction = linear;
					case "easeinquad":
						__easeFunction = easeInQuad;
					case "easeoutquad": 
						__easeFunction = easeOutQuad;
						break;
					case "easeinoutquad": 
						__easeFunction = easeInOutQuad;
						break;
					case "easeoutinquad": 
						__easeFunction = easeOutInQuad;
						break;
					case "easeincubic": 
						__easeFunction = easeInCubic;
						break;
					case "easeoutcubic": 
						__easeFunction = easeOutCubic;
						break;
					case "easeinoutcubic": 
						__easeFunction = easeInOutCubic;
						break;
					case "easeoutincubic": 
						__easeFunction = easeOutInCubic;
						break;
					case "easeinquart": 
						__easeFunction = easeInQuart;
						break;
					case "easeoutquart": 
						__easeFunction = easeOutQuart;
						break;
					case "easeinoutquart": 
						__easeFunction = easeInOutQuart;
						break;
					case "easeoutinquart": 
						__easeFunction = easeOutInQuart;
						break;
					case "easeinquint": 
						__easeFunction = easeInQuint;
						break;
					case "easeoutquint": 
						__easeFunction = easeOutQuint;
						break;
					case "easeinoutquint": 
						__easeFunction = easeInOutQuint;
						break;
					case "easeoutinquint": 
						__easeFunction = easeOutInQuint;
						break;
					case "easeinsine": 
						__easeFunction = easeInSine;
						break;
					case "easeoutsine": 
						__easeFunction = easeOutSine;
						break;
					case "easeinoutsine": 
						__easeFunction = easeInOutSine;
						break;
					case "easeoutinsine": 
						__easeFunction = easeOutInSine;
						break;
					case "easeincirc": 
						__easeFunction = easeInCirc;
						break;
					case "easeoutcirc": 
						__easeFunction = easeOutCirc;
						break;
					case "easeinoutcirc": 
						__easeFunction = easeInOutCirc;
						break;
					case "easeoutincirc": 
						__easeFunction = easeOutInCirc;
						break;
					case "easeinexpo": 
						__easeFunction = easeInExpo;
						break;
					case "easeoutexpo": 
						__easeFunction = easeOutExpo;
						break;
					case "easeinoutexpo": 
						__easeFunction = easeInOutExpo;
						break;
					case "easeoutinexpo": 
						__easeFunction = easeOutInExpo;
						break;
					case "easeinelastic": 
						__easeFunction = easeInElastic;
						break;
					case "easeoutelastic": 
						__easeFunction = easeOutElastic;
						break;
					case "easeinoutelastic": 
						__easeFunction = easeInOutElastic;
						break;
					case "easeoutinelastic": 
						__easeFunction = easeOutInElastic;
						break;
					case "easeinback": 
						__easeFunction = easeInBack;
						break;
					case "easeoutback": 
						__easeFunction = easeOutBack;
						break;
					case "easeinoutback": 
						__easeFunction = easeInOutBack;
						break;
					case "easeoutinback": 
						__easeFunction = easeOutInBack;
						break;
					case "easeinbounce": 
						__easeFunction = easeInBounce;
						break;
					case "easeoutbounce": 
						__easeFunction = easeOutBounce;
						break;
					case "easeinoutbounce": 
						__easeFunction = easeInOutBounce;
						break;
					case "easeoutinbounce": 
						__easeFunction = easeOutInBounce;
						break;
					default:
						__easeFunction = linear;
						break;
				}
			}
		}

		public function update( motiontime:int ):Boolean 
		{
			//overwrite in subclass
			return( false );
		}

		public function tweenComplete():void 
		{
			//overwrite in subclass
		}

		public function executeCallback():void 
		{
			if( __callback != null ) 
			{
				__callbackArgs.push( __timeDiff );
				__callback.apply( null, __callbackArgs );
			}
		}

		public function pause():void 
		{
			if( !__paused ) 
			{
				pauseItem( );
			}
			else 
			{
				resumeItem( );
			}
		}

		public function pauseItem():void 
		{
			if( !__paused ) 
			{
				__paused = true;
				__pauseTime = getTimer( );
			}
		}

		public function resumeItem():void 
		{
			if( __paused ) 
			{
				var resumeTime:int = getTimer( );
				var elapsedTime:int = resumeTime - __pauseTime;
				__starttime += elapsedTime;
				__endtime += elapsedTime;
				__currenttime += elapsedTime;
				__paused = false;
			}
		}

		private function ease( t:Number, b:Number, c:Number, d:Number ):Number 
		{
			return -c * (t /= d) * (t - 2) + b;
		}

		private function elastic( t:Number, b:Number, c:Number, d:Number, a:Number, p:Number ):Number 
		{
			var s:Number;
			if (t == 0) return b;  			if ((t /= d) == 1) return b + c;  			if (!p) p = d * .3;
			if (!a || a < Math.abs( c )) 
			{ 				a = c; 				s = p / 4; 			}
			else s = p / (2 * Math.PI) * Math.asin( c / a );
			return (a * Math.pow( 2, -10 * t ) * Math.sin( (t * d - s) * (2 * Math.PI) / p ) + c + b);
		}

		private function linear( t:Number, b:Number, c:Number, d:Number ):Number 
		{
			return c * t / d + b;
		}

		private function bounce( t:Number, b:Number, c:Number, d:Number ):Number 
		{
			if ((t /= d) < (1 / 2.75)) 
			{
				return c * (7.5625 * t * t) + b;
			} else if (t < (2 / 2.75)) 
			{
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			} else if (t < (2.5 / 2.75)) 
			{
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			} else 
			{
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
			}
		}

		/**

		 * Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInQuad(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * (t /= d) * t + b;
		}

		/**
		 * Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutQuad(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return -c * (t /= d) * (t - 2) + b;
		}

		/**
		 * Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutQuad(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d / 2) < 1) return c / 2 * t * t + b;
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}

		/**
		 * Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInQuad(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutQuad( t * 2, b, c / 2, d );

			return easeInQuad( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInCubic(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * (t /= d) * t * t + b;
		}

		/**
		 * Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutCubic(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * ((t = t / d - 1) * t * t + 1) + b;
		}

		/**
		 * Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutCubic(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;

			return c / 2 * ((t -= 2) * t * t + 2) + b;
		}

		/**
		 * Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInCubic(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutCubic( t * 2, b, c / 2, d );
			return easeInCubic( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInQuart(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * (t /= d) * t * t * t + b;
		}

		/**
		 * Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutQuart(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}

		/**
		 * Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutQuart(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;

			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}

		/**
		 * Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInQuart(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutQuart( t * 2, b, c / 2, d );

			return easeInQuart( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * (t /= d) * t * t * t * t + b;
		}

		/**
		 * Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}

		/**
		 * Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;

			return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
		}

		/**
		 * Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutQuint( t * 2, b, c / 2, d );

			return easeInQuint( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInSine(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return -c * Math.cos( t / d * (Math.PI / 2) ) + c + b;
		}

		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutSine(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * Math.sin( t / d * (Math.PI / 2) ) + b;
		}

		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutSine(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return -c / 2 * (Math.cos( Math.PI * t / d ) - 1) + b;
		}

		/**
		 * Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInSine(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutSine( t * 2, b, c / 2, d );

			return easeInSine( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInExpo(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return (t == 0) ? b : c * Math.pow( 2, 10 * (t / d - 1) ) + b - c * 0.001;
		}

		/**
		 * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutExpo(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return (t == d) ? b + c : c * 1.001 * (-Math.pow( 2, -10 * t / d ) + 1) + b;
		}

		/**
		 * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutExpo(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t == 0) return b;

			if (t == d) return b + c;

			if ((t /= d / 2) < 1) return c / 2 * Math.pow( 2, 10 * (t - 1) ) + b - c * 0.0005;

			return c / 2 * 1.0005 * (-Math.pow( 2, -10 * --t ) + 2) + b;
		}

		/**
		 * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInExpo(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutExpo( t * 2, b, c / 2, d );

			return easeInExpo( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInCirc(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return -c * (Math.sqrt( 1 - (t /= d) * t ) - 1) + b;
		}

		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutCirc(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c * Math.sqrt( 1 - (t = t / d - 1) * t ) + b;
		}

		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutCirc(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt( 1 - t * t ) - 1) + b;

			return c / 2 * (Math.sqrt( 1 - (t -= 2) * t ) + 1) + b;
		}
		
		/**
		 * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInCirc(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutCirc( t * 2, b, c / 2, d );

			return easeInCirc( (t * 2) - d, b + c / 2, c / 2, d );
		}
		
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		private function easeInElastic(t:Number, b:Number, c:Number, d:Number, period:*, amplitude:*):Number 
		{

			if (t == 0) return b;

			if ((t /= d) == 1) return b + c;

			var p:Number = !Boolean( period ) || isNaN( period ) ? d * .3 : period;

			var s:Number;

			var a:Number = !Boolean( amplitude ) || isNaN( amplitude ) ? 0 : amplitude;

			if (!Boolean( a ) || a < Math.abs( c )) 
			{

				a = c;

				s = p / 4;
			} else 
			{

				s = p / (2 * Math.PI) * Math.asin( c / a );
			}

			return -(a * Math.pow( 2, 10 * (t -= 1) ) * Math.sin( (t * d - s) * (2 * Math.PI) / p )) + b;
		}

		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		private function easeOutElastic(t:Number, b:Number, c:Number, d:Number, period:*, amplitude:*):Number 
		{

			if (t == 0) return b;

			if ((t /= d) == 1) return b + c;

			var p:Number = !Boolean( period ) || isNaN( period ) ? d * .3 : period;

			var s:Number;

			var a:Number = !Boolean( amplitude ) || isNaN( amplitude ) ? 0 : amplitude;

			if (!Boolean( a ) || a < Math.abs( c )) 
			{

				a = c;

				s = p / 4;
			} else 
			{

				s = p / (2 * Math.PI) * Math.asin( c / a );
			}

			return (a * Math.pow( 2, -10 * t ) * Math.sin( (t * d - s) * (2 * Math.PI) / p ) + c + b);
		}

		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		private function easeInOutElastic(t:Number, b:Number, c:Number, d:Number, period:Number, amplitude:Number):Number 
		{

			if (t == 0) return b;

			if ((t /= d / 2) == 2) return b + c;

			var p:Number = !Boolean( period ) || isNaN( period ) ? d * (.3 * 1.5) : period;

			var s:Number;

			var a:Number = !Boolean( amplitude ) || isNaN( amplitude ) ? 0 : amplitude;

			if (!Boolean( a ) || a < Math.abs( c )) 
			{

				a = c;

				s = p / 4;
			} else 
			{

				s = p / (2 * Math.PI) * Math.asin( c / a );
			}

			if (t < 1) return -.5 * (a * Math.pow( 2, 10 * (t -= 1) ) * Math.sin( (t * d - s) * (2 * Math.PI) / p )) + b;

			return a * Math.pow( 2, -10 * (t -= 1) ) * Math.sin( (t * d - s) * (2 * Math.PI) / p ) * .5 + c + b;
		}

		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		private function easeOutInElastic(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutElastic( t * 2, b, c / 2, d, null, null );

			return easeInElastic( (t * 2) - d, b + c / 2, c / 2, d, null, null );
		}

		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		private function easeInBack(t:Number, b:Number, c:Number, d:Number, overshoot:Number = 1.70158 ):Number 
		{

			//var s:Number = !Boolean( overshoot ) || isNaN( overshoot ) ? 1.70158 : overshoot;
			var s:Number = overshoot;
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}

		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		private function easeOutBack(t:Number, b:Number, c:Number, d:Number, overshoot:* ):Number 
		{

			var s:Number = !Boolean( overshoot ) || isNaN( overshoot ) ? 1.70158 : overshoot;

			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}

		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		private function easeInOutBack(t:Number, b:Number, c:Number, d:Number, overshoot:Number):Number 
		{

			var s:Number = !Boolean( overshoot ) || isNaN( overshoot ) ? 1.70158 : overshoot;

			if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;

			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}

		/**
		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
		 * @return		The correct value.
		 */
		private function easeOutInBack(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutBack( t * 2, b, c / 2, d, null );

			return easeInBack( (t * 2) - d, b + c / 2, c / 2, d );
		}

		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInBounce(t:Number, b:Number, c:Number, d:Number):Number 
		{

			return c - easeOutBounce( d - t, 0, c, d ) + b;
		}

		/**
		 *Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutBounce(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if ((t /= d) < (1 / 2.75)) 
			{

				return c * (7.5625 * t * t) + b;
			} else if (t < (2 / 2.75)) 
			{

				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			} else if (t < (2.5 / 2.75)) 
			{

				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			} else 
			{

				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
			}
		}

		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeInOutBounce(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeInBounce( t * 2, 0, c, d ) * .5 + b;

			else return easeOutBounce( t * 2 - d, 0, c, d ) * .5 + c * .5 + b;
		}

		/**
		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		private function easeOutInBounce(t:Number, b:Number, c:Number, d:Number):Number 
		{

			if (t < d / 2) return easeOutBounce( t * 2, b, c / 2, d );

			return easeInBounce( (t * 2) - d, b + c / 2, c / 2, d );
		}
	}
}