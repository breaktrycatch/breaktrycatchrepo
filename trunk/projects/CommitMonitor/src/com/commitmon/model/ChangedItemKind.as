package com.commitmon.model
{
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;

	[RemoteClass]
	public class ChangedItemKind
	{
		[Bindable]
		public var kind : int;
		
		public function ChangedItemKind(id : int = SVNNodeKind.NONE)
		{
			kind = id;
		}
	}
}