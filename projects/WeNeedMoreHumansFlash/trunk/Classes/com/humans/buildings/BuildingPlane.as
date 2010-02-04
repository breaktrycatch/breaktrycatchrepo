package com.humans.buildings {
	import com.humans.utils.elements.BitmapLoaderInstance;
	import com.humans.utils.events.BitmapLoadedEvent;

	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;

	import flash.display.Bitmap;

	/**
	 * @author jkeon
	 */
	public class BuildingPlane extends Plane {
		
		protected var __mc:BuildingMC;
		protected var __bLoaderInstance:BitmapLoaderInstance;
		protected var __bitmap:Bitmap;
		
		public function BuildingPlane(material : MaterialObject3D = null, width : Number = 0, height : Number = 0, segmentsW : Number = 0, segmentsH : Number = 0) {
			super(material, width, height, segmentsW, segmentsH);
		}
		
		public function reposition():void {
			//this.y = (mc.height/2);
			
		}
		
		public function get mc() : BuildingMC {
			return __mc;
		}
		
		public function set mc(_mc : BuildingMC) : void {
			__mc = _mc;
		}
		
		public function loadBitmap(_path:String):void {
			__bLoaderInstance = new BitmapLoaderInstance(_path);
			__bLoaderInstance.addEventListener(BitmapLoadedEvent.BITMAP_LOADED, onBitmapLoaded);
			__bLoaderInstance.loadBitmap();
		}
		
		protected function onBitmapLoaded(e:BitmapLoadedEvent):void {
			__bitmap = new Bitmap(e.bitmapData, "auto", true);
			__mc.addChild(__bitmap);
			reposition();
		}
	}
}
