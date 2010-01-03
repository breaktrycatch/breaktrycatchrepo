package com.valkryie.data.vo.core {
	import com.module_data.BindableArray;
	import com.module_data.BindableObject;

	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * Class that allows for easy Serialization/Deserialization
	 * of itself. All items that are bindable are also serializable.
	 * 
	 * @author plemarquand
	 */
	public class SerializableVO extends BindableObject
	{
		private var _vo : Object;
		private var _lastSavedVO : Object;
		private var _deserialized : Boolean;

		public function SerializableVO(target : IEventDispatcher = null)
		{
			_vo = new Object();
			_lastSavedVO = new Object();
			super(target);
		}

		override protected function set(prop : String, newValue : *) : void
		{
			_vo[prop] = newValue;
			super.set(prop, newValue);
		}

		public function get needsSave() : Boolean
		{
			return !compare(_vo, _lastSavedVO);
		}

		public function serialize() : Object
		{
			_lastSavedVO = copy(_vo);
			return _vo;
		}

		public function deserialize(obj : Object) : void
		{
			_deserialized = true;
			for (var i : String in obj) 
			{
				try
				{
					// the JSON serializer saves BindableArrays as arrays, so we have to marshal.
					if(obj[i] is Array && this[i] is BindableArray)
					{
						this[i] = new BindableArray();
						var spliceArgs : Array = [0,0].concat(obj[i]);
						BindableArray(this[i]).splice.apply(this, spliceArgs);
					}
					else
					{
						this[i] = obj[i];
					}
				}
				catch(e : Error)
				{
					// sigh, oh well, its probably an out of date parameter.
				}
			}
		}

		protected function copy(value : *) : *
		{
			var buffer : ByteArray = new ByteArray();  
			buffer.writeObject(value);  
			buffer.position = 0;  
			var result : Object = buffer.readObject();  
			return result;  	
		}

		private function compare( aObj : Object, bObj : Object ) : Boolean 
		{
			for (var i:String in aObj) 
			{
				if (typeof aObj[i] == "object") 
				{
					if (typeof bObj[i] == "object") 
					{
						if (!compare(aObj[i], bObj[i])) return false;
					} 
					else 
					{
						return false;
					}
				} 
				else 
				{
					if (bObj[i] != aObj[i]) return false;
				}
			}
			return true;
		}

		public function get deserialized() : Boolean
		{
			return _deserialized;
		}

		public function get name() : String
		{
			throw new Error("This method should be overwritten");
		}
	}
}
