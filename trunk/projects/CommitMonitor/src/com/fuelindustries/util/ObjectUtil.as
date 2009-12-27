package com.fuelindustries.util 
{

	/**
	 * Adapted from the Vegas Framework.
	 * http://vegas.googlecode.com
	 * 
	 * @author plemarquand
	 */
	public class ObjectUtil 
	{
		/**
		 * Returns <code class="prettyprint">true</code> if the specified object is a simple object.
		 * @return <code class="prettyprint">true</code> if the specified object is a simple object.
		 */ 
		public static function isSimple(value : Object) : Boolean 
		{
			var tof : String = typeof(value);
			switch (tof)
			{
				case "number":
				case "string":
				case "boolean":
					{
                       return true;
                }
                case "object":
                {
                    return (value is Date) || (value is Array);
                }
                default:
                {
                    return false; 
                }                
			}
		}
	}
}
