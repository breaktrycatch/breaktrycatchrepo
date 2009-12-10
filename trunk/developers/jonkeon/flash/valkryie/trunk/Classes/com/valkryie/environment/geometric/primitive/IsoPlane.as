package com.valkryie.environment.geometric.primitive {
	import com.valkryie.environment.geometric.component.IsoFace;
	import com.valkryie.environment.geometric.component.IsoVertex;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class IsoPlane extends Object {
		
		protected var __isoX:int;
		protected var __isoY:int;
		
		protected var __topLeftX:int;
		protected var __topLeftY:int;
		
		protected var __isoWidth:int;
		protected var __isoDepth:int;
		
		protected var __numSegmentsX:int;
		protected var __numSegmentsY:int;
		
		protected var __subDivisionXWidth:int;
		protected var __subDivisionYWidth:int;
		
		protected var __screenX:Number;
		protected var __screenY:Number;
		
		protected var __faces:Array;
		protected var __edges:Array;
		protected var __verticies:Array;
		
		protected var __texture:BitmapData;
		
		public function IsoPlane(_isoX:int, _isoY:int, _isoWidth:int, _isoDepth:int, _numSegmentsX:int, _numSegmentsY:int, _texture:BitmapData) {
			
			__isoX = _isoX;
			__isoY = _isoY;
			
			__isoWidth = _isoWidth;
			__isoDepth = _isoDepth;
			__topLeftX = __isoX - __isoWidth;
			__topLeftY = __isoY - __isoDepth;
			__numSegmentsX = _numSegmentsX;
			__numSegmentsY = _numSegmentsY;
			__texture = _texture;

			var pt:Point = IsoStatics.worldToScreen(__isoX, __isoY, 0);
			__screenX = pt.x;
			__screenY = pt.y;
			
			
			init();
		}
		
		public function updateScreenCoordinates():void {
			var pt:Point = IsoStatics.worldToScreen(__isoX, __isoY, 0);
			__screenX = pt.x;
			__screenY = pt.y;
		
			for (var i:int = 0; i<__faces.length; i++) {
				(__faces[i] as IsoFace).updateScreenCoordinates();
			}
		}
		
		public function set texture(_texture : BitmapData) : void {
			__texture = _texture;
		}
		
		protected function init():void {
			
			__subDivisionXWidth = __isoWidth/__numSegmentsX;
			__subDivisionYWidth = __isoDepth/__numSegmentsY;
			
			generateVerticies();
			generateFaces();
		}
		
		protected function generateVerticies():void {
			__verticies = [];
			var v:IsoVertex;
			var index:int;
			var randomZ:int;
			
			var h : int = __numSegmentsY + 1;
			var w : int = __numSegmentsX + 1;
			for(var y : int = 0; y < h; y++)
			{
				for(var x : int = 0; x < w; x++)
				{
					index = x + y*w;
					//randomZ = Math.floor(Math.random() * 32);
					randomZ = 0;
					v = new IsoVertex((x*__subDivisionXWidth) + __isoX,(y*__subDivisionYWidth) + __isoY, randomZ);
					
					v.u = x/__numSegmentsX;
					v.v = y/__numSegmentsY;
					
					__verticies[index] = v;
				}
			}
		}
		
		public function getFaces():Array {
			return __faces;
		}
		
		protected function generateFaces():void {
			__faces = [];

			
			var p:IsoFace;
			
			var index:int;
			var index2:int;
			for(var y : int = 0; y < __numSegmentsY; y++)
			{
				for(var x : int = 0; x < __numSegmentsX; x++)
				{
					index = x + y*(__numSegmentsX+1);
					index2 = x + ((y+1) * (__numSegmentsX+1));
					//0, 2, 1
					p = new IsoFace(__verticies[index], __verticies[index2], __verticies[index + 1], __subDivisionXWidth, __subDivisionYWidth,__isoWidth,__isoDepth,this);
					p.texture = __texture;
					__faces.push(p);
					//3, 1, 2
					p = new IsoFace(__verticies[index2 + 1], __verticies[index + 1], __verticies[index2],__subDivisionXWidth, __subDivisionYWidth,__isoWidth,__isoDepth,this);
					p.direction = -1;
					p.texture = __texture;
					
					__faces.push(p);
				}
			}
		}
		
		public function get screenX() : Number {
			return __screenX;
		}
		
		public function get screenY() : Number {
			return __screenY;
		}
	}
}
