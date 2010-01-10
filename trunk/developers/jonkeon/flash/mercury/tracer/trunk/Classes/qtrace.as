package {
	import com.module_tracer.core.TraceManager;	
	/**
	 * @author jkeon
	 */
	public function qtrace(...args):String {
		if ((TraceManager.LIVE_MODE && TraceManager.DEPLOYED_QUICK_TRACE) || (!TraceManager.LIVE_MODE && TraceManager.IDE_QUICK_TRACE)) {
			var output:String = "";
			output += args.join(" ");
			trace(output);
			return output;
		}
		return "";
	}
	
}
