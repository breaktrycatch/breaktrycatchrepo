package com.util
{
	import flash.utils.ByteArray;	

	/**
	 * A helper utility class for cloning objects.
	 **/
	public class CloneUtil
	{
		public static function clone(source : Object) : *
		{
			try
			{
				return _clone( source );
			}
            catch(e : Error)
			{
				trace("_clone()... " + e.getStackTrace());
				return source;
			}
		}

		public static function strongType(source : Object, type : String) : *
		{
			try
			{
				var clazz : Object = DescribeUtil.classReference( type );
                                
				DescribeUtil.registerClass( clazz );
                                
				var objectByteArray : ByteArray = new ByteArray( );
				objectByteArray.writeObject( source );
				objectByteArray.position = 0;
                            
				return objectByteArray.readObject( );
			} 
			catch(e : Error)
			{
				trace(e.getStackTrace());
				return source;
			}
		} 

		private static function _clone(source : Object) : *
		{
			// kludge!!
			if(source.hasOwnProperty( "clone" ))
			{
				return source;
			}
			
			DescribeUtil.registerClass( source );
			
			var classType 	: Class = DescribeUtil.classReference(source);
			var output 		: * = new classType();
			var props 		: Array = DescribeUtil.instance.propertyNameList( output );
			
			for each(var key:String in props)
			{
				var value : * = source[key];
				if(value is Array)
				{
					output[key] = [];
                                
					for each(var child:Object in value) 
					{ 
						output[key].push( _clone( child ) );
					}
				}
                else if(value is Object)
				{
					output[key] = value;
				}
			}
                    
			return output;
		}
	}
}
