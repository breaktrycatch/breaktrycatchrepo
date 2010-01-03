package com.valkryie.actor.geometric {
	import com.fuelindustries.core.AssetProxy;
	import com.module_assets.net.AssetManager;
	import com.valkryie.actor.StaticActor;
	import com.valkryie.data.vo.geometric.FaceVO;
	import com.valkryie.data.vo.geometric.VertexVO;
	import com.valkryie.environment.geometric.vector.Iso3DVector;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Jon
	 */
	public class FaceActor extends StaticActor {
		
		protected var __vertex0:VertexVO;
		protected var __vertex1:VertexVO;
		protected var __vertex2:VertexVO;
		
		protected var __v0u:Number;
		protected var __v0v:Number;
		protected var __v1u:Number;
		protected var __v1v:Number;
		protected var __v2u:Number;
		protected var __v2v:Number;
		
		protected var __renderCanvas:MovieClip;
		
		///// REDO? ////
		
		protected var __orderedVertices:Array;
		
		protected var __texture:BitmapData;
		protected var __mappedTexture:BitmapData;
		protected var __textureMatrix:Matrix;
		
		protected var __subWidth:int;
		protected var __subDepth:int;
		protected var __polyWidth:int;
		protected var __polyDepth:int;
		
		protected var __direction:int;
		
		protected var __screenBounds:Rectangle;
		protected var __localOffsetX:Number;
		protected var __localOffsetY:Number;
		
		protected var __screenX:Number;
		protected var __screenY:Number;
		
		protected var __normalVector:Iso3DVector;
		protected var __centroid:VertexVO;
		protected var __normalVertex:VertexVO;
		
		/// END REDO? ///
		
		public function FaceActor() {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			super();
		}
		
		protected override function init():void {
			super.init();
			__stringName = "FACE " + __id;
			__direction = 1;
		}
		
		override protected function completeConstruction() : void {
			super.completeConstruction();
			__renderCanvas = new MovieClip();
			this.addChild(__renderCanvas);
		}
		
		override protected function setupData() : void {
			__dataVO = new FaceVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
			
		}
		
		protected function reposition():void {
			calculateValues();
			render();
		}
		
		public function construct(_subWidth:Number, _subDepth:Number, _polyWidth:Number, _polyDepth:Number):void {
			__subWidth = _subWidth;
			__subDepth = _subDepth;
			__polyWidth = _polyWidth;
			__polyDepth = _polyDepth;
			
			__orderedVertices = [__vertex0, __vertex1, __vertex2];
			
			__texture = AssetManager.getInstance().getAsset("Texture_Default", true);
			
			__centroid = new VertexVO();
			__normalVertex = new VertexVO();
			
			__screenBounds = new Rectangle();
			
			__bindings.push(__vertex0.bind("isoX", this, reposition));
			__bindings.push(__vertex0.bind("isoY", this, reposition));
			__bindings.push(__vertex0.bind("isoZ", this, reposition));
			
			__bindings.push(__vertex1.bind("isoX", this, reposition));
			__bindings.push(__vertex1.bind("isoY", this, reposition));
			__bindings.push(__vertex1.bind("isoZ", this, reposition));
			
			__bindings.push(__vertex2.bind("isoX", this, reposition));
			__bindings.push(__vertex2.bind("isoY", this, reposition));
			__bindings.push(__vertex2.bind("isoZ", this, reposition));
			
			calculateValues();
		}
		
		protected function calculateValues():void {
			//Create Surface Normal
			var edge1:Iso3DVector = new Iso3DVector(__vertex1.isoX - __vertex0.isoX, __vertex1.isoY - __vertex0.isoY, __vertex1.isoZ - __vertex0.isoZ);
			var edge2:Iso3DVector = new Iso3DVector(__vertex2.isoX - __vertex0.isoX, __vertex2.isoY - __vertex0.isoY, __vertex2.isoZ - __vertex0.isoZ);
			
			__normalVector = Iso3DVector.normalize(Iso3DVector.crossProduct(edge1, edge2), true);
			__normalVector = Iso3DVector.multiplyScalar(__normalVector, 50, true);
			
			
			__centroid.isoX = (__vertex0.isoX + __vertex1.isoX + __vertex2.isoX)/3;
			__centroid.isoY = (__vertex0.isoY + __vertex1.isoY + __vertex2.isoY)/3;
			__centroid.isoZ = (__vertex0.isoZ + __vertex1.isoZ + __vertex2.isoZ)/3;
			
			__centroid.updateScreenCoordinates();
			
			__normalVertex.isoX = __centroid.isoX + __normalVector.x;
			__normalVertex.isoY = __centroid.isoY + __normalVector.y;
			__normalVertex.isoZ = __centroid.isoZ + __normalVector.z;
		
			__normalVertex.updateScreenCoordinates();
			
			
			var v:VertexVO;
			var minX:int = int.MAX_VALUE;
			var minY:int = int.MAX_VALUE;
			var maxX:int = int.MIN_VALUE;
			var maxY:int = int.MIN_VALUE;
			for (var i:int = 0; i < __orderedVertices.length; i++) {
				v = __orderedVertices[i];
				v.updateScreenCoordinates();
				if (v.transformedX < minX) {
					minX = v.transformedX;
				}
				if (v.transformedX > maxX) {
					maxX = v.transformedX;
				}
				if (v.transformedY < minY) {
					minY = v.transformedY;
				}
				if (v.transformedY > maxY) {
					maxY = v.transformedY;
				}
			}
			
			__screenX = ((minX + maxX)/2);
			__screenY = maxY;
			
			__localOffsetX = -minX;
			__localOffsetY = -minY;
			
			__screenBounds.x = 0;
			__screenBounds.y = 0;
			__screenBounds.width = maxX-minX;
			__screenBounds.height = maxY-minY;
			
			calculateTextureMatrix();
		}
		
		protected function calculateTextureMatrix():void {
		    //Declare Distort Matrix Values
		    var a:Number;
		    var b:Number;
		    var c:Number;
		    var d:Number;
		    var tx:Number;
		    var ty:Number;
		    
		    
		    var v1x:Number = __vertex0.transformedX + __localOffsetX;
		    var v1y:Number = __vertex0.transformedY + __localOffsetY;
		    
		    var v2x:Number = __vertex1.transformedX + __localOffsetX;
		    var v2y:Number = __vertex1.transformedY + __localOffsetY;
		    
		    var v3x:Number = __vertex2.transformedX + __localOffsetX;
		    var v3y:Number = __vertex2.transformedY + __localOffsetY;
		    
		    //If we have an upper triangle
		    if (__direction == 1) {
		    	//The values are calculated by screen coordinates
			    a = v3x - v1x;
			    b = v3y - v1y;
			    c = v2x - v1x;
			    d = v2y - v1y;
		    }
		    //We have a lower triangle
		    else {
		    	a = v1x - v3x;
			    b = v1y - v3y;
			    c = v1x - v2x;
			    d = v1y - v2y;
		    }
		    //TX and TY Offsets remain the same
		    tx = v1x;
		    ty = v1y;
			
			//Because we're technically mapping a rectangular texture, we need to use the maximum value of width/height
			var size:Number = Math.max(__subWidth, __subDepth);
			
			//The values of the a,b,c,d need to be normalized based on the size of the segment compared to the texure size.
			var widthNormalizer:Number = (size/__texture.width) * __texture.width;
			var heightNormalizer:Number = (size/__texture.height) * __texture.height;
			
			//Normalize the matrix values
			a /= widthNormalizer;
			b /= heightNormalizer;
			c /= widthNormalizer;
			d /= heightNormalizer;
			
			//Get the ratio of the Polygon width/depth to the texture
			var polyToTexDiffX:Number = __polyWidth/__texture.width;
			var polyToTexDiffY:Number = __polyDepth/__texture.height;
			
			
			var subToTexDiffX:Number = __texture.width/__subWidth;
			var subToTexDiffY:Number = __texture.height/__subDepth;
			
			var subRatio:Number = Math.min(subToTexDiffX, subToTexDiffY);
			
			subToTexDiffX/=subRatio;
			subToTexDiffY/=subRatio;
			
			var ratioX:Number = polyToTexDiffX * subToTexDiffX;
			var ratioY:Number = polyToTexDiffY * subToTexDiffY;
			
			var tsx:Number; 
			var tsy:Number; 
			
			if (__direction == 1) {
			 	tsx = (__v0u*__texture.width*ratioX);
			 	tsy = (__v0v*__texture.height*ratioY);
			}
			else {
				tsx = __v2u*__texture.width*ratioX;
			 	tsy = __v1v*__texture.height*ratioY;
			}
		
			__mappedTexture = new BitmapData(size,size, true, 0xFFFFFF);
			var uvMatrix:Matrix = new Matrix(ratioX, 0, 0, ratioY, -tsx, -tsy);
			__mappedTexture.draw(__texture, uvMatrix, null, null, null, true);
			
			
			__textureMatrix = new Matrix(a, b, c, d, tx, ty);
		}
		
		public function render():void {
			if (__texture != null) {
				var g:Graphics = __renderCanvas.graphics;
				g.clear();
				g.beginBitmapFill(__mappedTexture, __textureMatrix, true, true);
				g.moveTo(__vertex0.transformedX + __localOffsetX, __vertex0.transformedY + __localOffsetY);
				g.lineTo(__vertex1.transformedX + __localOffsetX, __vertex1.transformedY + __localOffsetY);
				g.lineTo(__vertex2.transformedX + __localOffsetX, __vertex2.transformedY + __localOffsetY);
				g.endFill();
				__renderCanvas.x = -(__renderCanvas.width/2);
				__renderCanvas.y = -(__renderCanvas.height);
				this.x = __screenX;
				this.y = __screenY;
			
			
				calculateBounds();
			}
			else {
				throw new Error("Polygon does not have a texture set");
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function get vertex0() : VertexVO {
			return __vertex0;
		}
		
		public function set vertex0(_vertex0 : VertexVO) : void {
			__vertex0 = _vertex0;
			__v0u = __vertex0["u"];
			__v0v = __vertex0["v"];
		}
		
		public function get vertex1() : VertexVO {
			return __vertex1;
		}
		
		public function set vertex1(_vertex1 : VertexVO) : void {
			__vertex1 = _vertex1;
			__v1u = __vertex1["u"];
			__v1v = __vertex1["v"];
		}
		
		public function get vertex2() : VertexVO {
			return __vertex2;
		}
		
		public function set vertex2(_vertex2 : VertexVO) : void {
			__vertex2 = _vertex2;
			__v2u = __vertex2["u"];
			__v2v = __vertex2["v"];
		}
		
		public function get direction() : int {
			return __direction;
		}
		
		public function set direction(_direction : int) : void {
			__direction = _direction;
		}
		
		public function get v0u() : Number {
			return __v0u;
		}
		
		public function set v0u(_v0u : Number) : void {
			__v0u = _v0u;
		}
		
		public function get v0v() : Number {
			return __v0v;
		}
		
		public function set v0v(_v0v : Number) : void {
			__v0v = _v0v;
		}
		
		public function get v1u() : Number {
			return __v1u;
		}
		
		public function set v1u(_v1u : Number) : void {
			__v1u = _v1u;
		}
		
		public function get v1v() : Number {
			return __v1v;
		}
		
		public function set v1v(_v1v : Number) : void {
			__v1v = _v1v;
		}
		
		public function get v2u() : Number {
			return __v2u;
		}
		
		public function set v2u(_v2u : Number) : void {
			__v2u = _v2u;
		}
		
		public function get v2v() : Number {
			return __v2v;
		}
		
		public function set v2v(_v2v : Number) : void {
			__v2v = _v2v;
		}
	}
}
