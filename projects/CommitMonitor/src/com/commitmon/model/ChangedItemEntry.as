package com.commitmon.model
{
	[RemoteClass]
	public class ChangedItemEntry
	{
		[Bindable]
		public var path:String;
		
		[Bindable]
		public var type:String;
		
		[Bindable]
		public var copyPath:String;
		
		[Bindable]
		public var copyRevision:int;
		
		[Bindable]
		public var nodeKind:ChangedItemKind;
		
		public function ChangedItemEntry()
		{
		}
	}
}