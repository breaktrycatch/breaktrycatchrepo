package com.sample.core {
	import com.module_tracer.core.TraceManager;
	import com.sample.dummy.DTraceExampleOne;
	import com.sample.dummy.ETraceExampleOne;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;

	/**
	 * @author jkeon
	 */
	public class SampleCore extends MovieClip {
		
		//Loosely typed because it's a pain to explicitly import fl packages and i'm lazy.
		public var uiscroller:*;
		
		//Buttons
		public var qtrace_btn:MovieClip;
		public var dtrace_btn:MovieClip;
		public var etrace_btn:MovieClip;
		
		public var qtraceLive_btn:MovieClip;
		public var dtraceLive_btn:MovieClip;
		public var etraceLive_btn:MovieClip;
		public var qtraceIDE_btn:MovieClip;
		public var dtraceIDE_btn:MovieClip;
		public var etraceIDE_btn:MovieClip;
		
		//Visible trace log
		public var traceLog_txt:TextField;
		protected var __traceLog:String;
		
		//Settings
		public var qtraceLive_txt:TextField;
		public var dtraceLive_txt:TextField;
		public var etraceLive_txt:TextField;
		
		public var qtraceIDE_txt:TextField;
		public var dtraceIDE_txt:TextField;
		public var etraceIDE_txt:TextField;
		
		public function SampleCore() {
			init();
		}
		
		protected function init():void {
			//Determine whether the player is running in the IDE or in a Deployed Environment
			//You can feel free to choose your own way of determining this.
			if (Capabilities.playerType == "External") {
				TraceManager.LIVE_MODE = false;
			}
			else {
				TraceManager.LIVE_MODE = true;
			}
			//Initialize the trace log to be empty
			__traceLog = "";
			
			//Setup the buttons
			setupButtons();
			
			//Initialize the textfields with the current default settings
			qtraceLive_txt.text = "QTRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_QUICK_TRACE;
			dtraceLive_txt.text = "DTRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_DEBUG_TRACE;
			etraceLive_txt.text = "ETRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_ERROR_TRACE;
			
			qtraceIDE_txt.text = "QTRACE IDE MODE ENABLED: " + TraceManager.IDE_QUICK_TRACE;
			dtraceIDE_txt.text = "DTRACE IDE MODE ENABLED: " + TraceManager.IDE_DEBUG_TRACE;
			etraceIDE_txt.text = "ETRACE IDE MODE ENABLED: " + TraceManager.IDE_ERROR_TRACE;
		}
		
		protected function setupButtons():void {
			//Just adds listeners
			qtrace_btn.buttonMode = true;
			qtrace_btn.useHandCursor = true;
			qtrace_btn.addEventListener(MouseEvent.CLICK, sampleQTrace);
			
			dtrace_btn.buttonMode = true;
			dtrace_btn.useHandCursor = true;
			dtrace_btn.addEventListener(MouseEvent.CLICK, sampleDTrace);
			
			etrace_btn.buttonMode = true;
			etrace_btn.useHandCursor = true;
			etrace_btn.addEventListener(MouseEvent.CLICK, sampleETrace);
			
			qtraceLive_btn.buttonMode = true;
			qtraceLive_btn.useHandCursor = true;
			qtraceLive_btn.addEventListener(MouseEvent.CLICK, qtraceLiveToggle);
			
			etraceLive_btn.buttonMode = true;
			etraceLive_btn.useHandCursor = true;
			etraceLive_btn.addEventListener(MouseEvent.CLICK, etraceLiveToggle);
			
			dtraceLive_btn.buttonMode = true;
			dtraceLive_btn.useHandCursor = true;
			dtraceLive_btn.addEventListener(MouseEvent.CLICK, dtraceLiveToggle);
			
			qtraceIDE_btn.buttonMode = true;
			qtraceIDE_btn.useHandCursor = true;
			qtraceIDE_btn.addEventListener(MouseEvent.CLICK, qtraceIDEToggle);
			
			dtraceIDE_btn.buttonMode = true;
			dtraceIDE_btn.useHandCursor = true;
			dtraceIDE_btn.addEventListener(MouseEvent.CLICK, dtraceIDEToggle);
			
			etraceIDE_btn.buttonMode = true;
			etraceIDE_btn.useHandCursor = true;
			etraceIDE_btn.addEventListener(MouseEvent.CLICK, etraceIDEToggle);
		}
		
		
		protected function sampleQTrace(e:MouseEvent):void {
			//Run the trace
			__traceLog += qtrace("This is a sample qtrace. It is identical to regular trace.") + "\n";
			//Handles placing it in the text field and updating the scrolling
			traceLog_txt.text = __traceLog;
			traceLog_txt.scrollV = traceLog_txt.maxScrollV;
			uiscroller.update();
		}
		
		protected function sampleDTrace(e:MouseEvent):void {
			
			var d1:DTraceExampleOne = new DTraceExampleOne();
			
			//Run the trace
			__traceLog += d1.callDTrace() + "\n";
			//Handles placing it in the text field and updating the scrolling
			traceLog_txt.text = __traceLog;
			traceLog_txt.scrollV = traceLog_txt.maxScrollV;
			uiscroller.update();
		}
		
		protected function sampleETrace(e:MouseEvent):void {
			var e1:ETraceExampleOne = new ETraceExampleOne();
			//Run the trace
			__traceLog += e1.callETrace() + "\n";
			//Handles placing it in the text field and updating the scrolling
			traceLog_txt.text = __traceLog;
			traceLog_txt.scrollV = traceLog_txt.maxScrollV;
			uiscroller.update();
		}
		
		protected function qtraceLiveToggle(e:MouseEvent):void {
			TraceManager.DEPLOYED_QUICK_TRACE = !TraceManager.DEPLOYED_QUICK_TRACE;
			qtraceLive_txt.text = "QTRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_QUICK_TRACE;
		}
		
		protected function dtraceLiveToggle(e:MouseEvent):void {
			TraceManager.DEPLOYED_DEBUG_TRACE = !TraceManager.DEPLOYED_DEBUG_TRACE;
			dtraceLive_txt.text = "DTRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_DEBUG_TRACE;
		}
		
		protected function etraceLiveToggle(e:MouseEvent):void {
			TraceManager.DEPLOYED_ERROR_TRACE = !TraceManager.DEPLOYED_ERROR_TRACE;
			etraceLive_txt.text = "ETRACE LIVE MODE ENABLED: " + TraceManager.DEPLOYED_ERROR_TRACE;
		}
		
		protected function qtraceIDEToggle(e:MouseEvent):void {
			TraceManager.IDE_QUICK_TRACE = !TraceManager.IDE_QUICK_TRACE;
			qtraceIDE_txt.text = "QTRACE IDE MODE ENABLED: " + TraceManager.IDE_QUICK_TRACE;
		}
		
		protected function dtraceIDEToggle(e:MouseEvent):void {
			TraceManager.IDE_DEBUG_TRACE = !TraceManager.IDE_DEBUG_TRACE;
			dtraceIDE_txt.text = "DTRACE IDE MODE ENABLED: " + TraceManager.IDE_DEBUG_TRACE;
		}
		
		protected function etraceIDEToggle(e:MouseEvent):void {
			TraceManager.IDE_ERROR_TRACE = !TraceManager.IDE_ERROR_TRACE;
			etraceIDE_txt.text = "ETRACE IDE MODE ENABLED: " + TraceManager.IDE_ERROR_TRACE;
		}
	}
}
