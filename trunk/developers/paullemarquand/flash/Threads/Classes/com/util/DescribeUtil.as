/* SVN FILE: $Id$ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright           Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link                        http://code.google.com/p/fake-as3/
 * @package                     fake
 * @subpackage          com.fake.utils
 * @since                       2008-03-06
 * @version                     $Revision$
 * @modifiedby          $LastChangedBy$
 * @lastmodified        $Date$
 * @license                     http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.util
{
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class DescribeUtil
	{
		/**
		 * map of currently defined classes
		 */
		private var _definitionMap : Object = {};
		/**
		 * map of currently described class
		 */
		private var _describeMap : Object = {};
		/**
		 * map of object properties
		 */
		private var _propertyNameMap : Object = {};
		/**
		 * hold the instance of the class
		 */
		private static const _instance : DescribeUtil = new DescribeUtil( );

		public function DescribeUtil() 
		{
		}

		/**
		 * Get the instance of the class.
		 */
		public static function get instance() : DescribeUtil
		{
			return _instance;
		}

		/**
		 * Get the xml description for the class and add it to the map table.
		 */
		public function describe(value : Object) : XML
		{
			var name : String = className( value );

			if(_describeMap[name] == null)
			{
				_describeMap[name] = describeType( value );
			}

			return XML( _describeMap[name] );
		}

		/**
		 * Get the definition by name and return class reference.
		 */
		public function definition(value : Object) : Class
		{
			var name : String = className( value );
                        
			if(_definitionMap[name] == null)
			{
				try 
				{
					_definitionMap[name] = getDefinitionByName( name );
				} catch(e : Error) 
				{
					trace(e.getStackTrace());
					return null;
				}
			}

			return Class( _definitionMap[name] );
		}

		/**
		 * Get a map object containing all variables and get/set accessors.
		 */
		public function properties(value : Object) : Object
		{
			var props : Object = {};

			for each(var prop:String in propertyNameList( value ))
			{
				props[prop] = value[prop];
			}

			return props;
		}

		/**
		 * Get a list of property name strings. Includes both variables and get/set accessors.
		 */
		public function propertyNameList(value : Object) : Array
		{
			var desc : XML = describe( value );
			var name : String = className( value );
			var propArray : Array = [];

			if(_propertyNameMap[name] == null)
			{
				for each(var node:XML in desc..variable)
				{
					if(node.metadata == null || node.metadata.@name == "Bindable" || node.metadata.@name != "Transient")
					{
						propArray.push( node.@name.toString( ) );
					}
				}

				for each(node in desc..accessor)
				{
					if(node.@access == 'readwrite')
					{
						propArray.push( node.@name.toString( ) );
					}
				}

				_propertyNameMap[name] = propArray;
			}

			return _propertyNameMap[name];
		}

		/**
		 * Grabs the local name of a class from its instance or string representation.
		 * 
		 * @param value String or Class that is to have it's local name extracted.
		 * @param isInstance Instances have getQualifiedClassName called on them.
		 */             
		public static function localName(value : Object) : String 
		{
			var name : String = className( value );
                        
			if(name.split( "::" ).length > 0)
                                return name.split( "::" )[1];
                        else
                                return name;
		}

		/**
		 * Returns the qualified class name.
		 */             
		public static function className(value : Object) : String
		{
			return getQualifiedClassName( value );
		}

		/**
		 * Converts QNames to class paths by replacing "::" with "."
		 */             
		public static function classPath(value : Object) : String 
		{
			return className( value ).replace( "::", "." );
		}

		/**
		 * Returns the Class references from a getClassByAlias call.
		 */             
		public static function classReference(value : Object) : Class
		{
			if(!(value is String))
                                value = classPath( value );
                        
			return ApplicationDomain.currentDomain.getDefinition( String( value ) ) as Class;
		}

		/**
		 * Takes an instance and registers its class. 
		 */             
		public static function registerClass(value : Object) : void
		{
			registerClassAlias( classPath( value ), instance.definition( value ) );
		}

		/**
		 * Helper function to allow for both rest array parameter or one array parameter.
		 */             
		public static function restFormat(restArray : Array) : Array
		{
			if(restArray[0] is Array)
                                restArray = restArray[0];
                        
			return restArray;
		}

		/**
		 * Empties _definitionMap, _describeMap and _propertyNameMap.
		 */             
		public function clear() : void
		{
			_definitionMap = {};
			_describeMap = {};
			_propertyNameMap = {};
		}

		
		public function get definitionMap() : Object 
		{
			return _definitionMap;
		}

		public function get describeMap() : Object 
		{
			return _describeMap;
		}

		public function get propertyNameMap() : Object 
		{
			return _propertyNameMap;
		}
	}
}
