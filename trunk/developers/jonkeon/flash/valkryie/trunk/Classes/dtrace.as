package {
	import com.module_tracer.core.TraceManager;	/**
	 * @author jkeon
	 */
	public function dtrace(...args):String {
		if ((TraceManager.LIVE_MODE && TraceManager.DEPLOYED_DEBUG_TRACE) || (!TraceManager.LIVE_MODE && TraceManager.IDE_DEBUG_TRACE)) {
			var output:String = "";
			var e:Error = new Error();
			var stackTrace:String = e.getStackTrace();
			//Don't have the Debug Player
			if (stackTrace == null) {
				output += "[DEBUG PLAYER NOT INSTALLED] ";
			}
			else {
				var lines:Array = stackTrace.split("\n");
				var relevantLine:String = lines[2];
				var startIndex:int;
				var endIndex:int; 
				var className:String;
				var culledLine:String;
				var functionName:String;
				var lineNumber:String;
				
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
					output += "[" + className + "::" + functionName + "] - ";
				}
				else {
					output += "[" + className + "::" + functionName + " : " + lineNumber + "] - ";
				}
				
				
			}
			
			output += args.join(" ");
			trace(output);
			return output;
			
		}
		return "";
	}
	
}
