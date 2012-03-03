package com.util.binding
{

	import com.util.binding.event.ModelChangeEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * A very bare bones binding implementation.
	 * Notifications occur immediately. For a deffered implementation, see
	 * http://bumpslide.com/blog/2009/03/04/data-binding-for-flash/
	 * 	 * @author plemarquand	 */
	public class BindableObject extends EventDispatcher
	{
		protected var __props : Dictionary;

		public function BindableObject(target : IEventDispatcher = null)
		{
			__props = new Dictionary();
			super( target );
		}

		/**
		 * Binds an object to a property in the inherited data model. 
		 * @param prop A string representation of the parameter you wish to bind to.
		 * @param target The context within which to execute the callback.
		 * @param setterOrFunction A function to execute when the target property changes, 
		 * or a string representation of the setter function to trigger. 
		 * If no function is specified, a setter with the same name as the first parameter is assumed.
		 * @return A binding object with information about the bind, as well as a function used to unbind.
		 */
		public function bind(_prop : String, _target : Object, _setterOrFunction : * = null, _initializeBinding : Boolean = true) : Binding
		{
			return Binding.create( this, _prop, _target, _setterOrFunction, _initializeBinding );
		}

		/**
		 * Retrieves a stored property from the data model. Bindable properties
		 * in the data model use getters and setters that wrap calls to the get/set
		 * implementations here. This allows for changes to be monitored and dispatched.
		 * 
		 * @example The following example shows how you would use this property in your
		 * concrete implementation of a BindableObject.
		 * <listing version="3.0">
		 * public function get userAge() : Number
		 * {
		 * 	return get('userAge');
		 * }
		 * </listing>
		 */
		protected function get(_prop : String) : *
		{
			return __props[_prop];
		}

		/**
		 * Sets a property in the data model. Bindable properties in the data model
		 * wrap this setter call to update their values. When a value is updated, a
		 * change event is fired that is run through the binding framework and which
		 * triggers the bound functions with the new value.
		 * 
		 * @example The following example shows how you would use this property in your
		 * concrete implementation of a BindableObject.
		 * <listing version="3.0">
		 * public function set userAge(val : Number) : void
		 * {
		 * 	return set('userAge', val);
		 * }
		 * </listing>
		 */
		protected function set(_prop : String, _newValue : *) : void
		{
			if (! equal( __props[_prop], _newValue ))
			{
				var oldValue : * = __props[_prop];
				__props[_prop] = _newValue;
				dispatchEvent( new ModelChangeEvent( this, _prop, _newValue, oldValue ) );
			}
		}

		/**
		 * Override this method if your concrete implementation of this BindableObject
		 * requires more than a simple double equals (==) comparison
		 */
		protected function equal(_item1 : *, _item2 : *) : Boolean
		{
			return _item1 == _item2;
		}

		/**
		 * Prepares the object for garbage collection.
		 */
		public function destroy() : void
		{
			__props = null;
		}
	}
}