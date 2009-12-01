package com.util 
{
	import com.breaktrycatch.collection.util.DictionaryExtensions;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * @author Paul
	 */
	public class Randomizer 
	{
		private var __rules : Dictionary;

		public function Randomizer( useDefaultRules : Boolean = false) 
		{
			__rules = new Dictionary( true );
			
			if(useDefaultRules)
			{
				initDefaultRules();
			}
		}

		private function initDefaultRules() : void
		{
			addRule( Number, null, -100, 100 );
			addRule( uint, null, 0, 0xffffff);
			addRule( int, null, -100, 100 );
		}

		public function addRule(cls : Class, property : String,  min : *, max : *) : void
		{
			if(__rules[cls] == null)
			{
				__rules[cls] = new Array( );
			}
			
			var arr : Array = __rules[cls];
			arr.push( new Rule( min, max, property ) );
		}

		public function clearRules() : void
		{
			__rules = new Dictionary( true );
		}

		public function randomize(obj : *) : *
		{
			if(!DictionaryExtensions.hasValues(__rules))
			{
				return obj;
			}
			
			var objectClass : Class;
			var child : XML;
			var propertyType : String;
			var propertyClass : Class;
			var objDescriptor : XML = DescribeUtil.describe( obj );
			
			for each(child in objDescriptor.children( ))
			{
				propertyType = getTypeFromDescriptor( child.@name, objDescriptor );
				
				if (propertyType != null)
				{
					propertyClass = getDefinitionByName( propertyType ) as Class;	
					
					if(!__rules[propertyClass])
					{
						continue;
					}
					
					var rules : Array = __rules[propertyClass];
					for (var j : Number = 0; j < rules.length ; j++) 
					{
						var rule : Rule = rules[j];
						if(rule.property == child.@name )
						{
							obj[child.@name] = rule.applyRule( obj[child.@name] );
						}
					}
				}					
			}	
			
			return obj;
		}

		private static function getTypeFromDescriptor(name : String, objDescriptor : XML) : String 
		{
			for each(var property:XML in objDescriptor.elements( "variable" )) 
			{
				if (property.@name == name)
				{
					return (String( property.@type ));
				}
			}
			for each(var accessor:XML in objDescriptor.elements( "accessor" )) 
			{
				if (accessor.@name == name)
				{
					return (String( accessor.@type ));  
				}
			}
			return null;
		}
	}
}

internal class Rule
{
	private var __min : *;
	private var __max : *;
	private var __property : String;
	
	public function Rule(min : *, max : *, property : String = null) 
	{
		__min = min;
		__max = max;
		__property = property;
	}
	
	public function get property():String
	{
		return __property;
	}

	public function applyRule( input : *) : *
	{
		var output : *;
		if(input is Boolean)
		{
			return (Math.random( ) < .5);	
		}
		else if(!isNaN( input ))
		{
			return __min + Math.random( ) * (__max - __min);
		} 
		else
		{
			return output;
		}
	}
}