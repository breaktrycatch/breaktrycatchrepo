package {
	import com.module_tracer.core.TraceManager;	/**
	 * @author jkeon
	 */
	public function etrace(...args):String {
		if ((TraceManager.LIVE_MODE && TraceManager.DEPLOYED_ERROR_TRACE) || (!TraceManager.LIVE_MODE && TraceManager.IDE_ERROR_TRACE)) {
			var output:String = "****[BEGIN STACK TRACE DUMP]****\n\t[USER PASSED PARAMS] - ";
			output += args.join(" ");
			output += "\n";
			var e:Error = new Error();
			var stackTrace:String = e.getStackTrace();
			
			trace(stackTrace);
			
			//Don't have the Debug Player
			if (stackTrace == null) {
				output += "[DEBUG PLAYER NOT INSTALLED] ";
			}
			else {
				var lines:Array = stackTrace.split("\n");
				var relevantLine:String;
				var startIndex:int;
				var endIndex:int; 
				var className:String;
				var culledLine:String;
				var functionName:String;
				var lineNumber:String;
				
				for (var i:int = 2; i<lines.length; i++) {
					output += "\t";
					relevantLine = lines[i];
					startIndex = relevantLine.indexOf("::");
					endIndex = relevantLine.indexOf("/"); 
					className = relevantLine.substring(startIndex + 2, endIndex);
					culledLine = relevantLine.substring(endIndex + 1, relevantLine.length);
					
					startIndex = culledLine.indexOf("::");
					endIndex = culledLine.lastIndexOf(")");
					functionName = culledLine.substring(startIndex + 1, endIndex + 1);
					
					startIndex = relevantLine.lastIndexOf(":");
					lineNumber = relevantLine.substring(startIndex + 1, relevantLine.length - 1);
					
					if (isNaN(parseInt(lineNumber))) {
						output += "[" + className + "::" + functionName + "]";
					}
					else {
						output += "[" + className + "::" + functionName + " : " + lineNumber + "]";
					}
					output += "\n";
				}
				output += "****[END STACK TRACE DUMP]****";
			}
			
			
			trace(output);
			return output;
		}
		return "";
	}
	
	
}
