package com.util
{

	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Object cloning and comparison utilities
	 * 
	 * This code was inspired by and borrowed from the 
	 * Flight Framework Type utility.
	 * 
	 * @author David Knape
	 */
	public class ObjectUtils
	{
		private static var registeredTypes : Dictionary = new Dictionary();

		public static function equals(value1 : Object, value2 : Object) : Boolean
		{
			if (value1 == value2)
			{
				return true;
			}
			if (value1 == null || value2 == null)
			{
				return false;
			}

			ObjectUtils.registerType( value1 );

			var so1 : ByteArray = new ByteArray();
			so1.writeObject( value1 );

			var so2 : ByteArray = new ByteArray();
			so2.writeObject( value2 );

			return Boolean( so1.toString() == so2.toString() );
		}

		public static function clone(value : Object) : Object
		{
			if (value == null) return null;

			ObjectUtils.registerType( value );

			var so : ByteArray = new ByteArray();
			so.writeObject( value );

			so.position = 0;
			return so.readObject();
		}

		/**
		 * Registers the class alias for this object so it can be
		 * cloned and compared as a byteArray
		 */
		public static function registerType(value : Object) : Boolean
		{
			if ( ! (value is Class) )
			{
				value = getType( value );
			}

			if (! registeredTypes[value])
			{
				// no need to register a class more than once
				registeredTypes[value] = registerClassAlias( getQualifiedClassName( value ).split( "::" ).join( "." ), value as Class );
			}

			return true;
		}

		/**
		 * Get the class name for an object
		 */
		public static function getType(value : Object) : Class
		{
			if (value is Class)
			{
				return value as Class;
			}
			else if (value is Proxy)
			{
				return getDefinitionByName( getQualifiedClassName( value ) ) as Class;
			}
			else
			{
				return value.constructor as Class;
			}
		}

		/**
		 * Merge properties from source into target
		 * 
		 * Assumes source is an object with enumerable properties
		 */
		public static function mergeProperties(source : *, target : *) : void
		{
			if (source != null && target != null)
				for ( var property_name:String in source )
				{
					try
					{
						target[property_name] = source[property_name];
					}
					catch (e : Error)
					{
					}
				}
		}
	}
}