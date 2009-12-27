package com.commitmon.model
{
	import flash.utils.Dictionary;
	
	[RemoteClass]
	public class CommitMonitorLogEntry
	{
		[Bindable]
		public var revision : int;
		
		[Bindable]
		public var author : String;
		
		[Bindable]
		public var message : String;
		
		[Bindable]
		public var date : Date;
		
		[Bindable]
		public var changedItems : Dictionary;
		
		[Bindable]
		public var viewed : Boolean;
	}
}