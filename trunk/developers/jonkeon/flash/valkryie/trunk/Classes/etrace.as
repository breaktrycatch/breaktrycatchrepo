package {
	import com.module_tracer.core.TraceManager;	/**
	 * @author jkeon
	 */
	public function etrace(...args):void {
		if ((TraceManager.LIVE_MODE && TraceManager.DEPLOYED_ERROR_TRACE) || (!TraceManager.LIVE_MODE && TraceManager.IDE_ERROR_TRACE)) {
			var output:String = "        ";
			var e:Error = new Error();
			var stackTrace:String = e.getStackTrace();
			
			//Don't have the Debug Player
			if (stackTrace == null) {
				output += "[DEBUG OFF] ";
			}
			else {
				var lines:Array = stackTrace.split("\n");
				var relevantLine:String = lines[2];
				var startIndex:int = relevantLine.lastIndexOf("\\");
				var culledLine:String = relevantLine.substring(startIndex + 1, relevantLine.length);
				output += "[" + culledLine;
			}
			
			output += args.join(" ");
			trace(output);
		}
	}
	
}
