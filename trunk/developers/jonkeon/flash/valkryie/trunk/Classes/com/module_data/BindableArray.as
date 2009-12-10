package com.module_data 
{
	import com.module_data.event.ModelChangeEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * An array that dispatched ModelChanged events when an item is added or
	 * removed from it. You can bind this array to objects using the <code>bind()</code> method.	 * @author plemarquand	 */	public dynamic class BindableArray extends Array implements IEventDispatcher
	{
		private const bindPropName : String = "bindProp";

		private var _dispatcher : IEventDispatcher;
		private var _props : Dictionary;
		public var bindProp : * = null;

		public function BindableArray(numElements : int = 0, ...args)
		{
			_dispatcher = new EventDispatcher( );
			_props = new Dictionary( );
			
			super( numElements );
			
			// initialize the array with the supplied arguments.
			if(args.length)
				this.push.apply( this, args );		}

		override AS3 function push(...args : *) : uint
		{
			// if we dont use apply() its treated as if we're using one argument of type array, instead of n seperate args.
			var newInt : uint = super.push.apply( this, args );
			bindProp = args;
			_dispatcher.dispatchEvent( new ModelChangeEvent( this, bindPropName, bindProp, null ) );
			return newInt;
		}

		override AS3 function pop() : *
		{
			bindProp = super.pop( );
			_dispatcher.dispatchEvent( new ModelChangeEvent( this, bindPropName, null, [bindProp] ) );
			return bindProp;
		}

		override AS3 function splice(...args) : *
		{
			var obj : Array = super.splice.apply( super, args );
			
			// are we adding?
			if(args.length > 2)
			{
				// remove the first 2 args and we're left with what we're adding.
				args.splice( 0, 2 );
				bindProp = args;
				_dispatcher.dispatchEvent( new ModelChangeEvent( this, bindPropName, bindProp, null ) );
			}
			else 
			{
				// nah we're deleting
				bindProp = obj;
				_dispatcher.dispatchEvent( new ModelChangeEvent( this, bindPropName, null, bindProp ) );
			}
			
			return obj;
		}

		override AS3 function shift() : *		{
			bindProp = super.shift( );
			_dispatcher.dispatchEvent( new ModelChangeEvent( this, bindPropName, null, [bindProp] ) );
			return bindProp;		}

		
		// Binding Methods

		public function bind( target : Object, setterOrFunction : *= null ) : Binding 
		{
			bindProp = this;
			return Binding.create( this, bindPropName, target, setterOrFunction );
		}

		public function unbind() : void
		{
			Binding.remove(bindPropName);
		}
		
		// IEventDispatcher Methods
		
		public function dispatchEvent(event : Event) : Boolean
		{			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type : String) : Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type : String) : Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_dispatcher.removeEventListener(type, listener, useCapture );
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		private var __id : Number = Math.random( );

		public function get id() : String 
		{
			return __id.toString( );
		}
	}}