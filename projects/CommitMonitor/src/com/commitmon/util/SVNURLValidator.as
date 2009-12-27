package com.commitmon.util
{
	import com.fuelindustries.svn.core.SVNURL;
	
	import mx.events.ValidationResultEvent;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class SVNURLValidator extends Validator
	{
		public function SVNURLValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			
			var val:String = value ? String(value) : "";
			if (results.length > 0 || ((val.length == 0) && !required))
				return results;
			else
			{
				try
				{
					// relies on the error handling in the constructor.
					var url : SVNURL = new SVNURL(value.toString(), false);
				} catch(e:Error)
				{
					results.push(new ValidationResult(true, null, "", "Invalid SVN URL"));
					return results;
				}
				
				return results;
			}
		}
	}
}