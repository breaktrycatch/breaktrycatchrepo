package com.valkryie.editor.brush {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.data.vo.AbstractBrushVO;
	import com.valkryie.environment.geometric.component.IsoVertex;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class AbstractBrush extends AbstractActor {
		
		protected var __topLeft:Point;
		protected var __topRight:Point;
		protected var __bottomRight:Point;
		protected var __bottomLeft:Point;
		
		protected var __subDFirst:Point;
		protected var __subDSecond:Point;
		protected var __subDPercentage:Number;
		protected var __subDValue:Number;
		
		protected var __outlineColor:Number;
		protected var __outlineAlpha:Number;
		protected var __fillColor:Number;
		protected var __fillAlpha:Number;
		
		protected var __overColorTransform:ColorTransform;
		protected var __normalColorTransform:ColorTransform;
		protected var __selectedColorTransform:ColorTransform;
		
		//Geometric Constructs
		protected var __verticies:Array;
		protected var __edges:Array;
		protected var __faces:Array;
		
		
		protected var __brushDisplay:MovieClip;
		protected var __vertexDisplay:MovieClip;
		protected var __edgeDisplay:MovieClip;
		protected var __faceDisplay:MovieClip;
		
		
		
		public function AbstractBrush() {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			super();
		}
		
		protected override function init():void {
			super.init();
			__verticies = [];
			__edges = [];
			__faces = [];
			__stringName = "PLANAR BRUSH " + __id;
			__brushDisplay = new MovieClip();
			__vertexDisplay = new MovieClip();
			__edgeDisplay = new MovieClip();
			__faceDisplay = new MovieClip();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			addChild(__brushDisplay);
			addChild(__vertexDisplay);
			addChild(__edgeDisplay);
			addChild(__faceDisplay);
			setupColorTransforms();
			
			this.useHandCursor = true;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, onMOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMOut);
		}
		

		override protected function setupData() : void {
			__dataVO = new AbstractBrushVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
			//Defaults
			__dataVO["isoX"] = 256;
			__dataVO["isoY"] = 256;
			__dataVO["isoDepth"] = 256;
			__dataVO["isoWidth"] = 256;
			__dataVO["subDivisionsX"] = 1;
			__dataVO["subDivisionsY"] = 1;
			
			__bindings.push(__dataVO.bind("isoX", this, render));
			__bindings.push(__dataVO.bind("isoY", this, render));
			__bindings.push(__dataVO.bind("isoDepth", this,  render));
			__bindings.push(__dataVO.bind("isoWidth", this, render));
			__bindings.push(__dataVO.bind("subDivisionsX", this, render));
			__bindings.push(__dataVO.bind("subDivisionsY", this, render));
		}
		
		protected function setupColorTransforms():void {
			//OVERRIDE
		}

		public function get isoWidth() : int {
			return dataRef.isoWidth;
		}
	
		public function get isoDepth() : int {
			return dataRef.isoDepth;
		}
		
		//Will need to change this to an as needed basis
		protected function updateGeometry():void {
			
			__verticies = [];
			
			var v:IsoVertex;
			var index:int;
			
			var h : int = __dataVO["subDivisionsY"] + 1;
			var w : int = __dataVO["subDivisionsX"] + 1;
			for(var y : int = 0; y < h; y++)
			{
				for(var x : int = 0; x < w; x++)
				{
					index = x + y*w;
					v = new IsoVertex((x*__dataVO["subDivisionsXSize"]) + __dataVO["isoX"],(y*__dataVO["subDivisionsYSize"]) + __dataVO["isoY"], 0);
				
					v.u = x/__dataVO["subDivisionsX"];
					v.v = y/__dataVO["subDivisionsY"];
					__verticies[index] = v;
				}
			}
			renderGeometry();
		}
		
		protected function renderGeometry():void {
			
//			var g:Graphics = __vertexDisplay.graphics;
//			g.clear();
//			var v:IsoVertex;
//			for (var b in __verticies) {
//				v = __verticies[b];
//				v.updateScreenCoordinates();
//				g.beginFill(0xFFFF00);
//				g.drawCircle(v.transformedX, v.transformedY, 4);
//				g.endFill();
//			}
		}
		
		//Renders the Brush
		public function render():void	{
			
			
			var g:Graphics = __brushDisplay.graphics;
			
			__topLeft = IsoStatics.worldToScreen(dataRef.isoX, dataRef.isoY, 0);
			__topRight = IsoStatics.worldToScreen(dataRef.isoX + dataRef.isoWidth, dataRef.isoY, 0);
			__bottomRight = IsoStatics.worldToScreen(dataRef.isoX + dataRef.isoWidth, dataRef.isoY + dataRef.isoDepth, 0);
			__bottomLeft = IsoStatics.worldToScreen(dataRef.isoX, dataRef.isoY + dataRef.isoDepth, 0);
			
			g.clear();
			
			g.lineStyle(3, __outlineColor, __outlineAlpha);
			g.beginFill(__fillColor, __fillAlpha);
			g.moveTo(__topLeft.x, __topLeft.y);
			g.lineTo(__topRight.x, __topRight.y);
			g.lineTo(__bottomRight.x, __bottomRight.y);
			g.lineTo(__bottomLeft.x, __bottomLeft.y);
			g.endFill();
			
			
			//Draw the Subdivisions
			for(var x:int = 1; x < __dataVO["subDivisionsX"]; x++) {
			
				__subDPercentage = x/__dataVO["subDivisionsX"];
				__subDValue = __subDPercentage*(dataRef.isoWidth) + dataRef.isoX;
				
				__subDFirst = IsoStatics.worldToScreen(__subDValue, dataRef.isoY, 0);
				__subDSecond = IsoStatics.worldToScreen(__subDValue, dataRef.isoY + dataRef.isoDepth, 0);
				
				g.moveTo(__subDFirst.x, __subDFirst.y);
				g.lineTo(__subDSecond.x, __subDSecond.y);
			}
			
			for(var y:int = 1; y < __dataVO["subDivisionsY"]; y++) {
			
				__subDPercentage = y/__dataVO["subDivisionsY"];
				__subDValue = __subDPercentage*(dataRef.isoDepth) + dataRef.isoY;
				
				__subDFirst = IsoStatics.worldToScreen(dataRef.isoX, __subDValue, 0);
				__subDSecond = IsoStatics.worldToScreen(dataRef.isoX + dataRef.isoWidth, __subDValue, 0);
				
				g.moveTo(__subDFirst.x, __subDFirst.y);
				g.lineTo(__subDSecond.x, __subDSecond.y);
			}
			
			updateGeometry();
		}
		
		
		public override function set selected(_selected : Boolean) : void {
			if (__selected != _selected) {
				__selected = _selected;
				if (__selected) {
					__brushDisplay.transform.colorTransform = __selectedColorTransform;
				}
				else {
					__brushDisplay.transform.colorTransform = __normalColorTransform;
				}
			}
		}
		
		
		
		
		
		
		private function get dataRef() : AbstractBrushVO {
			return __dataVO as AbstractBrushVO;
		}
		
		//INTERACTION HANDLERS
		
		protected function onMOver(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				__brushDisplay.transform.colorTransform = __overColorTransform;
			}
		}
		protected function onMOut(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				__brushDisplay.transform.colorTransform = __normalColorTransform;
			}
		}

		override public function destroy() : void {
			__topLeft = null;
			__topRight = null;
			__bottomRight = null;
			__bottomLeft = null;

			this.removeEventListener(MouseEvent.MOUSE_OVER, onMOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMOut);
			
			__overColorTransform = null;
			__normalColorTransform = null;
			__selectedColorTransform = null;
			
			__subDFirst = null;
			__subDSecond = null;
			
			
			
			super.destroy();
		}
	}
}
