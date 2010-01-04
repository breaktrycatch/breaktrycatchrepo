package com.valkryie.environment.render {
	import com.module_assets.net.AssetManager;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.geometric.FaceActor;
	import com.valkryie.actor.geometric.PolygonActor;
	import com.valkryie.actor.geometric.VertexActor;
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
		protected var __vertexMap:MovieClip;
		protected var __debugMap:MovieClip;
		
		protected var __actors:Array;
		protected var __vertices:Array;
		protected var __faces:Array;
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
			
			__vertexMap = new MovieClip();
			this.addChild(__vertexMap);
			
			__debugMap = new MovieClip();
			this.addChild(__debugMap);
			
			__actors = [];
			__vertices = [];
			__faces = [];
			__geometry = [];
			
			//Creates an arbitrary Rectangle, Overwritten in cullActors
			__actorCullingBounds = new Rectangle();
			__cameraCullingBounds = new Rectangle();
		}
		
		public function convertBrushToPoly(_brush:AbstractBrush):void {
			dtrace("Adding Vertex Actors");
			
			var orderedBrushVertices:Array = [];
			var index:int;
			var v:VertexActor;
			var h : int = _brush.dataVO["subDivisionsY"] + 1;
			var w : int = _brush.dataVO["subDivisionsX"] + 1;
			var subXAmount:Number = _brush.dataVO["isoWidth"]/_brush.dataVO["subDivisionsX"];
			var subYAmount:Number = _brush.dataVO["isoDepth"]/_brush.dataVO["subDivisionsY"];
			
			var x:int;
			var y:int;
			
			for(y = 0; y < h; y++)
			{
				for(x = 0; x < w; x++)
				{
					index = x + y*w;
					v = new VertexActor();
					v.linkDisplay();
					v.isoX = (x*subXAmount) + _brush.dataVO["isoX"];
					v.isoY = (y*subYAmount) + _brush.dataVO["isoY"];
					v.isoZ = 0;
					v.u = x/(w-1);
					v.v = y/(h-1); 
					orderedBrushVertices[index] = v.dataVO;
					addVertex(v);
					__vertexMap.addChild(v.display);
				}
			}
			
			dtrace("Adding Face Actors");
			
			var f:FaceActor;
			h--;
			w--;
			
			var index2:int;
			for(y = 0; y < h; y++)
			{
				for(x = 0; x < w; x++)
				{
					index = x + y*(w+1);
					index2 = x + ((y+1) * (w+1));
					//0, 2, 1
					f = new FaceActor();
					f.linkDisplay();
					f.vertex0 = orderedBrushVertices[index];
					f.vertex1 = orderedBrushVertices[index2];
					f.vertex2 = orderedBrushVertices[index + 1];
					f.construct(subXAmount, subYAmount, _brush.dataVO["isoWidth"], _brush.dataVO["isoDepth"]);
					f.render();
					__faces.push(f);
					__actorMap.addChild(f.display);
					
					//3, 1, 2
					f = new FaceActor();
					f.linkDisplay();
					f.vertex0 = orderedBrushVertices[index2 + 1];
					f.vertex1 = orderedBrushVertices[index + 1];
					f.vertex2 = orderedBrushVertices[index2];
					f.direction = -1;
					f.construct(subXAmount, subYAmount, _brush.dataVO["isoWidth"], _brush.dataVO["isoDepth"]);
					f.render();
					__faces.push(f);
					__actorMap.addChild(f.display);
				}
			}
			
			//Clean the ordered brush vertices
			for (var b in orderedBrushVertices) {
				orderedBrushVertices[b] = null;
			}
			orderedBrushVertices = null;
			
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
		
		//Add Vertex
		protected function addVertex(_vertex:VertexActor):void {
			__vertices.push(_vertex);
		}
		//Remove Vertex
		protected function removeVertex(_vertex:VertexActor):void {
			var index:int = __vertices.indexOf(_vertex);
			if (index != -1) {
				__vertices.splice(index, 1);
			}
		}
		//Show Vertices
		protected function showVertices():void {
			var v:VertexActor;
			for (var i:int = 0; i < __vertices.length; i++) {
				v = __vertices[i];
				__vertexMap.addChild(v.display);
			}
		}
		//Hide Vertices
		protected function hideVertices():void {
			var v:VertexActor;
			for (var i:int = 0; i < __vertices.length; i++) {
				v = __vertices[i];
				__vertexMap.removeChild(v.display);
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
		
		public function get vertices() : Array {
			return __vertices;
		}
	}
}
