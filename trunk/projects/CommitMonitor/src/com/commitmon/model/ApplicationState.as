package com.commitmon.model
{
	import com.fuelindustries.util.ArrayExtensions;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass]
	public class ApplicationState
	{
		[Bindable]
		public var projects : ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var currentProject : ProjectVO;
		
		public var aplicationPosX : Number = 0;
		public var aplicationPosY : Number = 0;
		public var applicationHeight : Number = 600;
		public var applicationWidth : Number = 330;
		
		public static var instance :  ApplicationState;
		
		public static function getInstance() :  ApplicationState
		{
			if( instance == null ) 
			{
				instance = new ApplicationState();
			}
			return instance;
		}
		
		public function removeProject(vo : ProjectVO):void
		{
			if(vo === currentProject)
			{
				currentProject = null;
			}
			
			projects.removeItemAt(projects.getItemIndex(vo));
		}
		
		public function setAllRevisionsViewed():void
		{
			ArrayExtensions.simpleForEach(projects.source, function(item : ProjectVO):void{
				item.markAllAsViewed();
			});
		}
		
		public function addProject(vo : ProjectVO):void
		{
			projects.addItem(vo);
			currentProject = vo;
		}
		
		public static function load():void
		{
			var loadedState : ApplicationState = DocumentService.load();
			instance = (loadedState) ? (loadedState) : (getInstance());
		}
		
		public static function save():void
		{
			DocumentService.save(instance);
		}
	}
}
