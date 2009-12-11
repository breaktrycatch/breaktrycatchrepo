package com.valkryie.environment.render {
	import com.module_assets.net.AssetManager;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.static.geometric.PolygonActor;
	import com.valkryie.editor.brush.AbstractBrush;
	import com.valkryie.environment.camera.IsoCamera;
	import com.valkryie.environment.geometric.component.IsoFace;
	import com.valkryie.environment.geometric.primitive.IsoPlane;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class IsoCanvas extends MovieClip {
		
		protected var __actorMap:MovieClip;
		protected var __debugMap:MovieClip;
		
		protected var __actors:Array;
		protected var __geometry:Array;
		
		//Reference to the Camera
		protected var __camera:IsoCamera;
		
		
		
		//Holder for CullingBounds
		protected var __actorCullingBounds:Rectangle;
		protected var __cameraCullingBounds:Rectangle;
		protected var __activeCullingActor:AbstractActor;
		
		//FLAGS
		public static var FLAG_DEBUG_OUTLINES:Boolean = false;
		public static var FLAG_DEBUG_NORMALS:Boolean = false;
		
		public function IsoCanvas(_camera:IsoCamera) {
			__camera = _camera;
			init();
		}
		
		protected function init():void {
			
			__actorMap = new MovieClip();
			this.addChild(__actorMap);
			
			__debugMap = new MovieClip();
			this.addChild(__debugMap);
			
			__actors = [];
			__geometry = [];
			
			//Creates an arbitrary Rectangle, Overwritten in cullActors
			__actorCullingBounds = new Rectangle();
			__cameraCullingBounds = new Rectangle();
		}
		
		public function addPlane(_planeBrush:AbstractBrush):void {
			var b:BitmapData = AssetManager.getInstance().getAsset("Texture_Default", true);
			var plane1:IsoPlane = new IsoPlane(_planeBrush.dataVO["isoX"], _planeBrush.dataVO["isoY"], _planeBrush.dataVO["isoWidth"], _planeBrush.dataVO["isoDepth"],_planeBrush.dataVO["subDivisionsX"],_planeBrush.dataVO["subDivisionsY"], b);
			
			
			__geometry.push(plane1);
			
			
			var pArray:Array = plane1.getFaces();			
			
			for (var i:int = 0; i<pArray.length; i++) {
				var pActor:PolygonActor = new PolygonActor();
				pActor.linkDisplay();
				pActor.isoFace = pArray[i] as IsoFace;
				//pActor.debugOutlines(__debugMap);
				//pActor.debugNormals(__debug);
				addActor(pActor);
			}
		}
		
		public function renderGeometry():void {
			var b:BitmapData = AssetManager.getInstance().getAsset("Texture_Arrow", true);
			var plane1:IsoPlane = new IsoPlane(0, 0, 512, 512,8,8, b);
			
			
			__geometry.push(plane1);
			
			
			var pArray:Array = plane1.getFaces();			
			
			for (var i:int = 0; i<pArray.length; i++) {
				var pActor:PolygonActor = new PolygonActor();
				pActor.linkDisplay();
				pActor.isoFace = pArray[i] as IsoFace;
				//pActor.debugOutlines(__debugMap);
				//pActor.debugNormals(__debug);
				addActor(pActor);
			}
		}
		
		public function updateScreenCoordinates():void {
			for (var i:int = 0; i< __geometry.length; i++) {
				__geometry[i].updateScreenCoordinates();
			}
			
			for (var j:int = 0; j< __actors.length; j++) {
				__actors[j].updateScreenCoordinates();
				__actors[j].debugOutlines(__debugMap);
			}
		}
		
		
		//Add Geometry to the Level
		public function addGeometry(_plane:IsoPlane):void {
			__geometry.push(_plane);
		}
		
		//Remove Geometry from the Level
		public function removeGeometry(_plane:IsoPlane):void {
			var index:int = __geometry.indexOf(_plane);
			if (index != -1) {
				__geometry.splice(index, 1);
			}
		}
		
		
		
		//Add Actors to the Canvas
		public function addActor(_actor:AbstractActor):void {
			__actors.push(_actor);
			__actorMap.addChild(_actor.display);
		}
		
		//Remove Actors from the Canvas
		public function removeActor(_actor:AbstractActor):void {
			var index:int = __actors.indexOf(_actor);
			if (index != -1) {
				if (_actor.parent == __actorMap) {
					__actorMap.removeChild(_actor.display);
				}
				__actors.splice(index, 1);
			}
			
		}
		
		public function cullActors():void {
			
			//For each actor, determine if it's hidden or showing.
			var b:Rectangle;
			var c:Rectangle;
			
			c = __camera.viewableArea;
			__cameraCullingBounds.x = c.x - x;
			__cameraCullingBounds.y = c.y - y;
			__cameraCullingBounds.width = c.width;
			__cameraCullingBounds.height = c.height;
			
			for (var i:int = 0; i < __actors.length; i++) {
				
				__activeCullingActor = __actors[i] as PolygonActor;
				
				b = __activeCullingActor.bounds;
				__actorCullingBounds.x = b.x;
				__actorCullingBounds.y = b.y;
				__actorCullingBounds.width = b.width;
				__actorCullingBounds.height = b.height;
			
				
				if (__cameraCullingBounds.intersects(__actorCullingBounds)) {
					if (__activeCullingActor.parent == null) {
						//dtrace("Adding Actor " + __activeCullingActor);
						__actorMap.addChild(__activeCullingActor.display);
					}
				}
				else {
					if (__activeCullingActor.parent == __actorMap) {
						//dtrace("Removing Actor " + __activeCullingActor);
						__actorMap.removeChild(__activeCullingActor.display);
					}
				}
	
			}

		}
		
		//		public function depthSort() : void 
//		{
//			//sorts the array based on the y values. Precendence goes to the top. Bottom is the highest depth (closest to screen).
//			//__tiles.sortOn( ["zDepth", "id", "uniqueIdentifier"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC] ); 
//			__tiles.sortOn( ["isoZ", "screenY"], [Array.NUMERIC, Array.NUMERIC] ); 
//			//get the length of the array
//			var i : int = __tiles.length;
//			//go through the entire array
//			while(i--)
//			{
//				//trace("ACTOR " + __actors[i] + " LOCK DEPTH " + __actors[i].lockZDepth + " DEPTH VALUE " + __actors[i].zDepth);
//				try 
//				{
//					//if the entity on the screen is not in order...
//					if (__canvas.getChildAt( i ) != __tiles[i].mc) 
//					{
//						//set it to be in order
//						__canvas.setChildIndex( __tiles[i].mc, i );
//					}
//				}
//				catch (e : Error) 
//				{
//					trace( "[Abstract Environment] - Depth Sort issue " + i + " " + __tiles + " " + __canvas.numChildren );	
//				}
//			}
//		}


		public function clearDebug():void {
			__debugMap.graphics.clear();
		}
		
		public function get debugMap() : MovieClip {
			return __debugMap;
		}
	}
}
