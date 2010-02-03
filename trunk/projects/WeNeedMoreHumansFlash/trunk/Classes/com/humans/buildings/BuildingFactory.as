package com.humans.buildings {
	import com.humans.buildings.events.BuildingCreatedEvent;
	import com.humans.utils.elements.BitmapLoaderInstance;
	import com.humans.utils.events.BitmapLoadedEvent;
	import com.module_subscriber.core.Subscriber;

	import org.papervision3d.materials.MovieMaterial;

	import flash.display.Bitmap;

	/**
	 * @author jkeon
	 */
	public class BuildingFactory extends Object {
		
		private static var __instance:BuildingFactory;
		
		protected var __bLoaders:Array;
		
		public function BuildingFactory() {
			if (__instance == null) {
				super();
				__bLoaders = [];
			} 
			else {
				throw new Error("[BUILDING FACTORY] - Can't Instantiate More than Once");
			}
		}
		
		public static function getInstance():BuildingFactory {
			if (__instance == null) {
				__instance = new BuildingFactory();
			}
			
			return __instance;
		}
		
		public function createBuilding(_path:String):void {
			
			var b:BitmapLoaderInstance = new BitmapLoaderInstance(_path);
			b.addEventListener(BitmapLoadedEvent.BITMAP_LOADED, onBitmapLoaded);
			b.loadBitmap();
		
		}
		
		protected function onBitmapLoaded(e:BitmapLoadedEvent):void {
			
			var b:BitmapLoaderInstance  = (e.target as BitmapLoaderInstance);
			b.removeEventListener(BitmapLoadedEvent.BITMAP_LOADED, onBitmapLoaded);
			b = null;
			
			var mc:BuildingMC = new BuildingMC();
			mc.linkDisplay();
			mc.addChild(new Bitmap(e.bitmapData, "auto", true));
			
			var movieMaterial:MovieMaterial = new MovieMaterial(mc.display, true);
			movieMaterial.interactive = true;
			
			var bp:BuildingPlane = new BuildingPlane(movieMaterial, mc.width, mc.height);
			bp.mc = mc;
			mc.building = bp;
			
			Subscriber.issue(new BuildingCreatedEvent(BuildingCreatedEvent.BUILDING_CREATED, bp));
			
		}
	}
}
