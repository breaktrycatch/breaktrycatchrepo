package com.valkryie.actor.static.geometric {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.static.StaticActor;
	import com.valkryie.data.statics.AppStatics;
	import com.valkryie.environment.geometric.component.IsoFace;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author jkeon
	 */
	public class PolygonActor extends StaticActor {
		
		protected var __isoFace:IsoFace;
		protected var __renderCanvas:MovieClip;
		
		public function PolygonActor() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			__renderCanvas = new MovieClip();
			this.addChild(__renderCanvas);
		}

		public function set isoFace(_isoFace : IsoFace) : void {
			__isoFace = _isoFace;
			__isoFace.render(__renderCanvas.graphics);
			//Position the Canvas based on the Render
			__renderCanvas.x = -(__renderCanvas.width/2);
			__renderCanvas.y = -(__renderCanvas.height);
			this.x = __isoFace.screenX;
			this.y = __isoFace.screenY;
			
			
			calculateBounds();
			
			/*
			//BASIC BASIC LIGHTING
			//We will assume 0 = 0x000000 at 50%
			//We will assume 32 = 0x000000 at 0%
			
			var zValue:Number = __isoFace.centroid.isoZ;
			var percentage:Number = zValue/32;
			var value:Number = percentage*50;
			
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x000000;
			ct.blueMultiplier = value/100;
			ct.redMultiplier = value/100;
			ct.greenMultiplier = value/100;
			
			dtrace("Value " + value);
			
			this.display.transform.colorTransform = ct;
			*/
			
			//BLUE is Canvas
			//this.graphics.lineStyle(3,0x0000FF);
			//this.graphics.drawRect(__renderCanvas.x, __renderCanvas.y, __renderCanvas.width, __renderCanvas.height);
		}
		
		public function debugNormals(_debugLayer:MovieClip):void {
			__isoFace.debugNormals(_debugLayer);
		}
		
		public function debugOutlines(_debugLayer:MovieClip):void {
			__isoFace.debugOutlines(_debugLayer);
		}
		
		public function updateScreenCoordinates():void {
			__isoFace.render(__renderCanvas.graphics);
			//Position the Canvas based on the Render
			__renderCanvas.x = -(__renderCanvas.width/2);
			__renderCanvas.y = -(__renderCanvas.height);
			this.x = __isoFace.screenX;
			this.y = __isoFace.screenY;
			
			
			calculateBounds();
		}	
		
	}
}
