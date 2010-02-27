package com.humans.ui.view {
	import com.humans.controls.scrollers.TowerScroller;
	import com.fuelindustries.controls.scrollers.ScrollBar;
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.events.ScrollEvent;
	import com.humans.manager.TowerManager;
	import com.humans.manager.event.TowerManagerEvent;
	import com.humans.ui.view.BaseView;

	import flash.display.Bitmap;

	/**
	 * @author fuel
	 */
	public class TowerGalleryView extends BaseView {
		
		//public var scroller_mc:TowerScroller;
		public var towerContainer_mc:AssetProxy;
		
		private var _towerManager:TowerManager = TowerManager.getInstance();
		private var _currentTowerIndex:int;
		private var _currentTower:Bitmap;
		
		public function TowerGalleryView() 
		{
			super();
			dtrace("CREATED");
			linkage = "TowerGallerView_mc";
		}

		override protected function completeConstruction() : void 
		{
			super.completeConstruction();
			
			dtrace("CONStructed");
			dtrace(this.display);
			//scroller_mc.enabled = false;
//			scroller_mc.addEventListener(ScrollEvent.SCROLL, onScrollerScroll);
		}

		override protected function onAdded() : void {
			super.onAdded();
			dtrace("ADDED");
			_towerManager.initialize();
			_towerManager.addEventListener(TowerManagerEvent.MANAGER_READY, onTowerManagerReady);
		}

		private function onTowerManagerReady(e : TowerManagerEvent) : void {
			_towerManager.removeEventListener(TowerManagerEvent.MANAGER_READY, onTowerManagerReady);
			_towerManager.addEventListener(TowerManagerEvent.TOWER_READY, onTowerReady);
			_towerManager.getTower(0);
		}
		
		private function onTowerReady(e : TowerManagerEvent) : void {
			if(_currentTower != null) {
				towerContainer_mc.removeChild(_currentTower);
			}
			
			_currentTower = e.tower;
			towerContainer_mc.addChild(_currentTower);
		}

		
		
		
		private function onScrollerScroll(e : ScrollEvent) : void 
		{
			switch(e.percent)
			{
				case -1:
					nextTower();
					break;
					
				case 1:
					previousTower();
					break;
			}
		}
		
		private function nextTower() : void {
			
			_currentTowerIndex = (_currentTowerIndex + 1) % _towerManager.towerCount;
			
			changeTower();
		}

		private function previousTower() : void 
		{
			_currentTowerIndex--;
			
			if(_currentTowerIndex < 0)
			{
				_currentTowerIndex += _towerManager.towerCount;
			}
			
			changeTower();
		}
		
		private function changeTower():void
		{
			_towerManager.getTower(_currentTowerIndex);
		}
		
	}
}
