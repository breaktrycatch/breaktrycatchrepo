package com.fuelindustries.svn.core 
{
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;

	/**
	 * @author julian
	 */
	public class SVNLogEntryPath 
	{
		public static const TYPE_ADDED:String = "A";
		public static const TYPE_DELETED:String = "D";
		public static const TYPE_MODIFIED:String = "M";
		public static const TYPE_REPLACED:String = "R";
		
		public var myPath:String;
		public var myType:String;
		public var myCopyPath:String;
		public var myCopyRevision:int;
		public var myNodeKind:SVNNodeKind;

		public function SVNLogEntryPath( path:String, type:String, copyPath:String, copyRevision:int,  kind:SVNNodeKind) 
		{
			myPath = path;
			myType = type;
			myCopyPath = copyPath;
			myCopyRevision = copyRevision;
			myNodeKind = kind;
		}

		public function toString():String 
		{
			var result:String = '';
			result += myType;
			result += ' ';
			result += myPath;
			if (myCopyPath != null) 
			{
				result += "(from ";
				result += myCopyPath;
				result += ':';
				result += myCopyRevision;
				result += ')';
			}
			return result;
		}
	}
}
