package com.valkryie.environment.geometric.component {
	import com.valkryie.environment.geometric.primitive.IsoPlane;
	import com.valkryie.environment.geometric.vector.Iso3DVector;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class IsoFace extends Object {
		
		//World Coordinates
		protected var __vertex1:IsoVertex;
		protected var __vertex2:IsoVertex;
		protected var __vertex3:IsoVertex;
		
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
		protected var __centroid:IsoVertex;
		protected var __normalVertex:IsoVertex;
		
		protected var __parentPlane:IsoPlane;
		
		public function IsoFace(_vertex1:IsoVertex, _vertex2:IsoVertex, _vertex3:IsoVertex, _subWidth:Number, _subDepth:Number, _polyWidth:Number, _polyDepth:Number, _planeReference:IsoPlane) {
			__vertex1 = _vertex1;
			__vertex2 = _vertex2;
			__vertex3 = _vertex3;
			__subWidth = _subWidth;
			__subDepth = _subDepth;
			__polyWidth = _polyWidth;
			__polyDepth = _polyDepth;
			__parentPlane = _planeReference;
			
			__direction = 1;
			
			init();
		}
		
		protected function init():void {
			__orderedVertices = [__vertex1, __vertex2, __vertex3];
			
			
			//Create Surface Normal
			var edge1:Iso3DVector = new Iso3DVector(__vertex2.isoX - __vertex1.isoX, __vertex2.isoY - __vertex1.isoY, __vertex2.isoZ - __vertex1.isoZ);
			var edge2:Iso3DVector = new Iso3DVector(__vertex3.isoX - __vertex1.isoX, __vertex3.isoY - __vertex1.isoY, __vertex3.isoZ - __vertex1.isoZ);
			
			__normalVector = Iso3DVector.normalize(Iso3DVector.crossProduct(edge1, edge2), true);
			__normalVector = Iso3DVector.multiplyScalar(__normalVector, 50, true);
			
			__centroid = new IsoVertex((__vertex1.isoX + __vertex2.isoX + __vertex3.isoX)/3, (__vertex1.isoY + __vertex2.isoY + __vertex3.isoY)/3, (__vertex1.isoZ + __vertex2.isoZ + __vertex3.isoZ)/3);
			__centroid.updateScreenCoordinates();
			
			
			__normalVertex = new IsoVertex((__centroid.isoX + __normalVector.x), (__centroid.isoY + __normalVector.y), (__centroid.isoZ + __normalVector.z));
			__normalVertex.updateScreenCoordinates();
			
			
			var v:IsoVertex;
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
			
			__screenBounds = new Rectangle(0, 0, maxX-minX, maxY-minY);
		}
		
		public function updateScreenCoordinates():void {
			
			//TODO: Clean and make efficient
			init();
			
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
		    
		    
		    var v1x:Number = __vertex1.transformedX + __localOffsetX;
		    var v1y:Number = __vertex1.transformedY + __localOffsetY;
		    
		    var v2x:Number = __vertex2.transformedX + __localOffsetX;
		    var v2y:Number = __vertex2.transformedY + __localOffsetY;
		    
		    var v3x:Number = __vertex3.transformedX + __localOffsetX;
		    var v3y:Number = __vertex3.transformedY + __localOffsetY;
		    
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
			 	tsx = (__vertex1.u*__texture.width*ratioX);
			 	tsy = (__vertex1.v*__texture.height*ratioY);
			}
			else {
				tsx = __vertex3.u*__texture.width*ratioX;
			 	tsy = __vertex2.v*__texture.height*ratioY;
			}
		
			__mappedTexture = new BitmapData(size,size, true, 0xFFFFFF);
			var uvMatrix:Matrix = new Matrix(ratioX, 0, 0, ratioY, -tsx, -tsy);
			__mappedTexture.draw(__texture, uvMatrix, null, null, null, true);
			
			
			__textureMatrix = new Matrix(a, b, c, d, tx, ty);
		}
		
		public function render(_graphics:Graphics):void {
			if (__texture != null) {
				_graphics.clear();
				_graphics.beginBitmapFill(__mappedTexture, __textureMatrix, true, true);
				_graphics.moveTo(__vertex1.transformedX + __localOffsetX, __vertex1.transformedY + __localOffsetY);
				_graphics.lineTo(__vertex2.transformedX + __localOffsetX, __vertex2.transformedY + __localOffsetY);
				_graphics.lineTo(__vertex3.transformedX + __localOffsetX, __vertex3.transformedY + __localOffsetY);
				_graphics.endFill();
			}
			else {
				throw new Error("Polygon does not have a texture set");
			}
		}
		
		
		public function debugNormals(_debugLayer:MovieClip):void {
			var g:Graphics = _debugLayer.graphics;
			g.lineStyle(3, 0x33FF00);
			g.moveTo(__centroid.transformedX, __centroid.transformedY);
			g.lineTo(__normalVertex.transformedX, __normalVertex.transformedY);
			g.drawCircle(__normalVertex.transformedX, __normalVertex.transformedY, 4);
		}
		
		public function debugOutlines(_debugLayer:MovieClip):void {
			var g:Graphics = _debugLayer.graphics;
			g.lineStyle(3, 0x6699FF);
			g.moveTo(__vertex1.transformedX, __vertex1.transformedY);
			g.lineTo(__vertex2.transformedX, __vertex2.transformedY);
			g.lineTo(__vertex3.transformedX, __vertex3.transformedY);
			g.lineTo(__vertex1.transformedX, __vertex1.transformedY);
		}
		
		
		public function set texture(_texture : BitmapData) : void {
			__texture = _texture;
			calculateTextureMatrix();
		}
		
		public function set direction(_direction : int) : void {
			__direction = _direction;
		}
		
		public function get screenX() : Number {
			return __screenX;
		}
		public function get screenY() : Number {
			return __screenY;
		}
		
		public function get centroid() : IsoVertex {
			return __centroid;
		}
	}
}
