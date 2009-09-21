package com.breaktrycatch.module_autoui 
{	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	/**	 * @author plemarquand	 */	public class AutoUIGenerator 
	{
		private static var _savedTypes : Dictionary = new Dictionary( true );
		private var _target : *;
		private var _targetList : Array;

		public function AutoUIGenerator(target : *) 
		{
			_target = target;
			_targetList = [_target];
		}
		
		/**
		 * Generates the UI and adds it to the supplied container.
		 * @param container A container to add UI elements to.
		 */
		public function generate(container : DisplayObjectContainer) : void
		{
			var ctr : int = 0;
			var objType : String = getQualifiedClassName( _target );
			var objDescriptor : XML = _savedTypes[objType] ? _savedTypes[objType] : describeType( _target );
			for each ( var property : XML in objDescriptor..*.( name( ) == "variable" || (name( ) == "accessor") && attribute( "access" ) == "readwrite" && attribute( "declaredBy" ) == objType ) )
			{
				var propertyValue : * = _target[property.@name];
				var component : Component = parseProperty( propertyValue, property.@name );
				if(component != null)
				{
					var nameField : TextField = new TextField();
					nameField.text = property.@name;
					nameField.x = ctr * 100;
					
					container.addChild( nameField );
					component.x = ctr * 100;
					component.y = 15;
					container.addChild( component );
				}
				ctr++;
			}
			_savedTypes[objType] = objDescriptor;
		}
		
		/**
		 * Adds an instance of the class to be observed. Its public properties
		 * will automatically be updated by the generated UI elements.
		 * @param target A target object to observe. It must be of the same type as
		 * the root target passed in to the constructor.
		 */
		public function addObserver(target : *) : void
		{
			var targetClass : Class = getDefinitionByName(getQualifiedClassName( _target ) ) as Class;
			if(target is targetClass)
			{
				_targetList.push(target);
			}
			else
			{
				throw new ArgumentError("Argument must be of type" + getQualifiedClassName(_target) + " but was instead a " + targetClass);
			}
		}
		
		private function parseProperty(propertyValue : *, name : String) : Component
		{
			var tof:String = typeof(propertyValue);
            switch (tof)
            {
                case "number":
                	return handleNumber(propertyValue, name);
                	break;
                case "string":
                	return handleString(propertyValue, name);
                	break;
                case "boolean":
                    return handleBoolean(propertyValue, name);
                    break; 
                default:
                	return null;
                	break;
            }			
		}
		
		private function handleNumber(value : Number, name : String):Component
		{
			var input : InputText = new InputText( null, 0, 0, value.toString(), function(e : Event):void
			{
				for (var i : Number = 0; i < _targetList.length; i++) 
				{
					_targetList[i][name] = Number(input.text);	
				}
			} );
			input.restrict = "0-9";
			input.text = value.toString();
			return input ;
		}
		
		private function handleBoolean(value : Boolean, name : String):Component
		{
			var input : CheckBox = new CheckBox( null, 0, 0, value.toString(), function(e : Event):void
			{
				for (var i : Number = 0; i < _targetList.length; i++) 
				{
					_targetList[i][name] = input.selected;	
				}
			} );
			input.selected = value;
			return input;
		}
		
		private function handleString(value : String, name : String):Component
		{
			var input : InputText = new InputText( null, 0, 0, value, function(e : Event):void
			{
				for (var i : Number = 0; i < _targetList.length; i++) 
				{
					_targetList[i][name] = input.text;	
				}
			} );
			input.text = value;
			return input;
		}	}}