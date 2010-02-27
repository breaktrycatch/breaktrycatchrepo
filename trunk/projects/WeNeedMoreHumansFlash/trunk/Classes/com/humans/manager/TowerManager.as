package com.humans.manager {
	import com.fuelindustries.net.assetmanager.events.AssetCompleteEvent;
	import com.fuelindustries.net.assetmanager.statics.AssetStatics;
	import com.fuelindustries.net.assetmanager.core.AssetManager;
	import com.humans.manager.event.TowerManagerEvent;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author fuel
	 */
	public class TowerManager extends EventDispatcher{
		
		private static var _instance:TowerManager;
		private static var _allowInstantiation:Boolean = false;
		public static function getInstance():TowerManager
		{
			if(_instance == null) {
				_allowInstantiation = true;
				_instance = new TowerManager();
				_allowInstantiation = false;
			}
			
			return _instance;
		}
		
		private const TOWER_MANIFEST:String = "TowerManifest";
		private const TOWER_DATA:String = "TowerData";
		private const TOWER_PATH:String = "../xml/";
		private var _loader:AssetManager = AssetManager.getInstance();
		private var _towerPaths:Array;
		private var _towers:Array = new Array();
		private var _loadingIndex:int = -1;
		
		public function get towerCount():int
		{
			return _towers.length;
		}
		
		public function get isReady():Boolean
		{
			return _towerPaths != null;
		}
		
		
		public function TowerManager(target : IEventDispatcher = null) {
			
			super(target);
			
			if(!_allowInstantiation)
			{
				throw new Error("[TOWER MANAGER] - Cannot directly instatiate a singleton please use getInstance().");
			}
			
			_loader.addEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete);
		}
		

		public function initialize():void
		{
			_loader.addAsset(TOWER_PATH + "manifest.xml", AssetStatics.GROUP_TOWERMANIFEST, TOWER_MANIFEST);
			_loader.loadGroup(AssetStatics.GROUP_TOWERMANIFEST);
		}
		
		public function getTower(index:int):void
		{
			if(_towers[index] != null)
			{
				dispatchEvent(new TowerManagerEvent(TowerManagerEvent.TOWER_READY, _towers[index]));
			}
			else
			{
				_loader.cleanGroup(AssetStatics.GROUP_TOWERLOADER);
				_loadingIndex = index;
//				_loader.addAsset(TOWER_PATH + _towerPaths[index], AssetStatics.GROUP_TOWERLOADER, TOWER_DATA);
				_loader.addAsset(TOWER_PATH + _towerPaths[index], AssetStatics.GROUP_TOWERLOADER);
				_loader.loadGroup(AssetStatics.GROUP_TOWERLOADER);
			}
		}
		
		private function onAssetComplete(e : AssetCompleteEvent) : void 
		{
			switch(e.group)
			{
				case AssetStatics.GROUP_TOWERMANIFEST:
//					processManifest(_loader.getFile(TOWER_MANIFEST) as XML);
					processManifest(_loader.getFile("manifest") as XML);
					break;
					
				case AssetStatics.GROUP_TOWERLOADER:
					//TODO: Implement
					_towers[_loadingIndex] = _loader.getAsset(TOWER_DATA,true);
					dispatchEvent(new TowerManagerEvent(TowerManagerEvent.TOWER_READY, _towers[_loadingIndex]));
					_loader.cleanGroup(AssetStatics.GROUP_TOWERLOADER);
					_loadingIndex = -1;
					break;
			}
		}
		
		private function processManifest(xml : XML) : void 
		{
			var towerXML:XMLList = xml..tower;
			_towerPaths = new Array();
			
			for(var i:int = 0; i<towerXML.length(); i++)
			{
				_towerPaths.push(towerXML[i].text());
			}
			
			dispatchEvent(new TowerManagerEvent(TowerManagerEvent.MANAGER_READY));
		}
		
		
	}
}
