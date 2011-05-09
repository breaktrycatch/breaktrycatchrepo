package com.util
{

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * @author plemarquand
	 * @author rwarren
	 */
	public class ReflectionUtils
	{
		// Cache's existing types so we save the call time -- No weak keys because this is the only place it is referenced
		private static var __xmlCache : Dictionary = new Dictionary();

		/**
		 * Takes an object and a name of a property on that object, and returns
		 * the properties' type.
		 * 
		 * @param obj An object who has the property name.
		 * @param name A property name.
		 * @return The propertie's type.
		 */
		public static function derivePropertyType(_obj : Object, _propName : String) : Class
		{
			var typeDescription : XML = getDescription( _obj );

			// TODO: could we not use selectors somehow to do this instead of iterating?
			for each ( var property : XML in typeDescription..*)
			{
				if ((property.name() == "variable" || property.name() == "accessor") && property.@name == _propName)
				{
					return getDefinitionByName( property.@type ) as Class;
				}
			}

			return null;
		}

		/**
		 * Determines the access level of a property (read only, write only, and read write).
		 * Public variables are AccessLevel.READ_WRITE.
		 * 
		 * @param _obj An object that has the property name.
		 * @param _name A property name.
		 * @return The access level of the variable.
		 */
		public static function getPropertyAccessLevel(_obj : Object, _propName : String) : AccessLevel
		{
			var typeDescription : XML = getDescription( _obj );

			// TODO: could we not use selectors somehow to do this instead of iterating?
			for each ( var property : XML in typeDescription..*)
			{
				if ((property.name() == "variable" || property.name() == "accessor") && property.@name == _propName)
				{
					if (property.name() == "accessor")
					{
						return AccessLevel.getLevel( property.@access );
					}
					else
					{
						return AccessLevel.READ_WRITE;
					}
				}
			}

			// dynamic object's properties are awlays read write if they dont exist.
			if (typeDescription.@isDynamic == "true")
			{
				return AccessLevel.READ_WRITE;
			}

			throw new ArgumentError( "Property " + _propName + " does not exist on " + getQualifiedClassName( _obj ) );
		}

		/**
		 * Returns an array with the string names of all non-dynamic public properties or variables
		 * on a given object.
		 * 
		 * @param _obj An object or Class to collect public properties or variable names of. 
		 * @return An array of string property or variable names.
		 */
		public static function getPublicProperties(_obj : Object) : Array
		{
			var typeDescription : XML = getDescription( _obj );

			var props : Array = [];
			// TODO: could we not use selectors somehow to do this instead of iterating?
			for each ( var property : XML in typeDescription..*)
			{
				if ((property.name() == "variable" || property.name() == "accessor") )
				{
					var name : String = property.@name;
					props.push( name );
				}
			}
			return props;
		}

		/**
		 * Checks an object to see if it contains all of the properties passed. If the object 
		 * is null returns false.
		 * 
		 * @param _obj The object to check for properties on
		 * @param _props An array of property names represented as strings
		 * 
		 * @return True if all of the properties exist on the object
		 */
		public static function hasProperties(_obj : Object, _props : Array) : Boolean
		{
			// check to make sure the object is not null
			if (_obj == null)
			{
				return false;
			}

			for each (var prop : String in _props)
			{
				if (_obj.hasOwnProperty( prop ) == false)
				{
					return false;
				}
			}

			return true;
		}

		/**
		 * Returns true of the supplied object is dynamic.
		 * 
		 * @param obj An object.
		 * @return If the object is dynamic.
		 */
		public static function isDynamic(_obj : Object) : Boolean
		{
			return getDescription( _obj ).@isDynamic == "true";
		}

		/**
		 * Given an object this method returns its class type.
		 * 
		 * @param value An object whose class you wish to derive.
		 * @return The supplied obect's class.
		 */
		public static function getClass(_value : *) : Class
		{
			return (_value == null) ? (null) : (getDefinitionByName( getQualifiedClassName( _value ) ) as Class);
		}

		/**
		 * Function courtesy of Colin Moock that determines if a class has a given
		 * ancestor in its inheritance chain.
		 * 
		 * @param _descendant The Class you are testing
		 * @param _ancestor The Class you are testing against
		 * @return Boolean of whether the descendant is an actual descendant of the ancestor
		 */
		public static function inheritsFrom(_descendant : Class, _ancestor : Class) : Boolean
		{
			if (_descendant == null || _ancestor == null || ! isClass( _ancestor ) || ! isClass( _descendant ))
			{
				return false;
			}
			else
			{
				var superName : String;
				var ancestorClassName : String = getQualifiedClassName( _ancestor );
				while (superName != "Object")
				{
					superName = getQualifiedSuperclassName( _descendant );
					if (superName == ancestorClassName)
					{
						return true;
					}
					else if (superName == null)
					{
						// its an interface, it cant inherit from object.
						return false;
					}
					_descendant = Class( getDefinitionByName( superName ) );
				}
				return false;
			}
		}

		/**
		 * Determines if the given class is a class (as opposed to an interface or null).
		 * 
		 * @param _clazz The class to check.
		 * @return True if _clazz is a Class or false otherwise.
		 */
		public static function isClass(_clazz : Class) : Boolean
		{
			return _clazz != null && ! isInterface( _clazz );
		}

		/**
		 * Determines if the given class is an interface (as opposed to a class or null).
		 * 
		 * @param _clazz The interface to check.
		 * @return True if _clazz is a interface or false otherwise.
		 */
		public static function isInterface(_clazz : Class) : Boolean
		{
			return _clazz != null && (_clazz === Object) ? false : getQualifiedSuperclassName( _clazz ) == null;
		}

		/**
		 * Determines if a class implements a given interface in its inheritance chain.
		 * 
		 * @param _descendant The Class you are testing
		 * @param _ancestor The Interface you are testing against
		 * @return Boolean of whether the descendant is an actual descendant of the ancestor
		 */
		public static function implementsFrom(_descendant : Class, _ancestor : Class) : Boolean
		{
			if (_descendant == null || _ancestor == null || ! isInterface( _ancestor ))
			{
				return false;
			}
			else
			{
				var typeDescription : XML = getDescription( _descendant );
				var ancestorName : String = getQualifiedClassName( _ancestor );
				var list : XMLList;

				// If the class has been instanciated (not dynamic) then the data is in the description rather than the factory
				if (typeDescription.@isDynamic == "true")
				{
					list = typeDescription['factory']['implementsInterface'];
				}
				else
				{
					list = typeDescription['implementsInterface'];
				}

				for (var i : int = 0; i < list.length(); i++)
				{
					if (list[i].@type == ancestorName)
					{
						return true;
					}
				}

				return false;
			}
		}

		/**
		 * Determines if an object inherits from a given class. The ancestor class
		 * can be located anywhere in the inheritance chain.
		 * @param _object The object you are testing with.
		 * @param _ancestor The class you are looking for in the inheritance chain.
		 */
		public static function objectInheritsFrom(_object : Object, _ancestor : Class) : Boolean
		{
			return ReflectionUtils.inheritsFrom( getDefinitionByName( getQualifiedClassName( _object ) ) as Class, _ancestor );
		}

		/**
		 * Given a container class this method returns all items of that type on the class.
		 * @param _container An object that has items on it you wish to find.
		 * @param _cls The type of objects you're looking for on the container.
		 * @param _includeSubClasses If you want to include objects defined in sub classes in the result.
		 * @param _includeConstants If you want to include constants in the class in the result.
		 */
		public static function getAllObjectsOfType(_container : Object, _cls : Object, _includeSubClasses : Boolean = false, _searchStatics : Boolean = false) : Array
		{
			var arr : Array = [];
			var qualifiedName : String = getQualifiedClassName( _cls );
			var searchClass : Class;
			if (_includeSubClasses)
			{
				searchClass = getDefinitionByName( qualifiedName ) as Class;
			}
			var xml : XML = getDescription( _container );
			var property : XML;
			var isInterface : Boolean = isInterface( searchClass );
			
			
			for each ( property in xml..*)
			{
				if ((property.name() == "variable" || property.name() == "accessor" || (_searchStatics && property.name() == "constant")) && getPropertyAccessLevel( _container, property.@name ).isReadable())
				{
					if (_container[property.@name] != null && (property.@type == qualifiedName || (_includeSubClasses && (isInterface ? ReflectionUtils.implementsFrom( getDefinitionByName( property.@type ) as Class, searchClass ) : ReflectionUtils.inheritsFrom( getDefinitionByName( property.@type ) as Class, searchClass )))))
					{
						arr.push( _container[property.@name] );
					}
				}
			}

			return arr;
		}

		/**
		 * Returns an XML description identical to that returned by the native function
		 * describeType(). However, if this type has been described before it is pulled
		 * from a cache, saving time. This is an example of memoization.
		 * @param _obj The object whose XML definition you wish to fetch
		 * @return The XML definition of the object emitted by describeType.
		 */
		public static function getDescription(_obj : Object) : XML
		{
			var qualifiedClassName : String = getQualifiedClassName( _obj );
			if (! (__xmlCache[qualifiedClassName] is XML))
			{
				__xmlCache[qualifiedClassName] = describeType( _obj );
			}
			return __xmlCache[qualifiedClassName];
		}

		/**
		 * Clears the XML description cache, freeing up any memory that has been
		 * allocated to it.
		 */
		public static function clearDescriptionCache() : void
		{
			__xmlCache = new Dictionary();
		}

		/**
		 * Attempts to derive the property's name by searching the supplied class for
		 * values that match the supplied value. If a class contains two public fields
		 * with the same value, the first one will be returned. This method will only return
		 * the names of public fields and properties.
		 * 
		 * <code>
		 * var rect : Rectangle = new Rectangle( 5, 10, 50, 100 );
		 * ReflectionUtils.derivePropertyName( 5 ); // will return "x".
		 * </code>
		 * 
		 * @param _obj The object whose values you wish to search.
		 * @param _value The value of the target property name you wish to find.
		 * @return The name of the property that has the given value.
		 */
		public static function derivePropertyName(_obj : *, _value : *) : String
		{
			var typeDescription : XML = ReflectionUtils.getDescription( _obj );
			for each ( var property : XML in typeDescription..*)
			{
				var isVarOrAccessor : Boolean = ( property.name() == "variable" || property.name() == "accessor" );
				var isConstant : Boolean = (property.name() == "constant");

				var level : String = property.@access;
				var access : AccessLevel = ( level ) ? (AccessLevel.getLevel( level ) ) : AccessLevel.READ_WRITE;
				if ( ( isVarOrAccessor || isConstant ) && access.isReadable() )
				{
					if (_obj[property.@name] === _value)
					{
						return property.@name;
					}
				}
			}
			return null;
		}
		
		/**
		 * Constructs a new object of the supplied type with the given constructor
		 * arguments.
		 * 
		 * @param _type The type of object you wish to create
		 * @param _args The constructor arguments for that object.
		 * @return A newly instantiated object of the supplied type.
		 */
		public static function create(_type : Class, _args : Array = null) : *
		{
			var argLength : int = _args ? _args.length : 0;

			switch(argLength)
			{
				case 0:
					return new _type();
				case 1:
					return new _type( _args[0] );
				case 2:
					return new _type( _args[0], _args[1] );
				case 3:
					return new _type( _args[0], _args[1], _args[2] );
				case 4:
					return new _type( _args[0], _args[1], _args[2], _args[3] );
				case 5:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4] );
				case 6:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4], _args[5] );
				case 7:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6] );
				case 8:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7] );
				case 9:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8] );
				case 10:
					return new _type( _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9] );
				default:
					throw new ArgumentError( "Reflection utils create does not support " + argLength + " add another case statement to this method or refactor your class" );
			}
		}

		/**
		 * Returns <code class="prettyprint">true</code> if the specified object is a simple object.
		 * 
		 * @return <code class="prettyprint">true</code> if the specified object is a simple object.
		 */
		public static function isSimple(value : Object) : Boolean
		{
			if (value == null)
			{
				return true;
			}

			var tof : String = typeof(value);
			switch (tof)
			{
				case "int":
				case "uint":
				case "number":
				case "string":
				case "boolean": {
					return true;
				}
				case "object": {
					return value is Array;
				}
				default: {
					return false; 
				}
			}
		}

		/**
		 * Determines if a class is a primitive type.
		 * 
		 * @return <code class="prettyprint">true</code> if the specified Class is a simple type.
		 */
		public static function isClassSimple(value : Class) : Boolean
		{
			switch (value)
			{
				case int:
				case uint:
				case Number:
				case String:
				case Boolean:
				case Array: {
					return true;
				}
				default: {
					return false; 
				}
			}
		}
	}
}
class AccessLevel
{
	public static var READ_ONLY : AccessLevel = new AccessLevel( "readonly" );
	public static var WRITE_ONLY : AccessLevel = new AccessLevel( "writeonly" );
	public static var READ_WRITE : AccessLevel = new AccessLevel( "readwrite" );
	private static var VALUES : Array = [ READ_WRITE, READ_ONLY, WRITE_ONLY ];
	public var description : String;

	public function AccessLevel(_description : String)
	{
		this.description = _description;
	}

	/**
	 * Indicates if the access level allows the variable to be written to.
	 * @return false if the value is read only.
	 */
	public function isWritable() : Boolean
	{
		return ! (this == AccessLevel.READ_ONLY);
	}

	/**
	 * Indicates if the access level allows the variable to be read.
	 * @return false if the value is write only.
	 */
	public function isReadable() : Boolean
	{
		return ! (this == AccessLevel.WRITE_ONLY);
	}

	/**
	 * Given one of the values generated by describeType for access level, returns
	 * the corresponding access level for the item.
	 * @param property An access level generated by describeType()
	 * @return The property's access level enumeration value.
	 */
	public static function getLevel(property : String) : AccessLevel
	{
		for each (var level : AccessLevel in VALUES)
		{
			if (level.description == property)
			{
				return level;
			}
		}
		throw new Error( "Invalid level " + property + " supplied" );
	}
}
