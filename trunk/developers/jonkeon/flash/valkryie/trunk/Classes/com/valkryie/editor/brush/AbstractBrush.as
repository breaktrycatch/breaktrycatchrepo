package com.valkryie.editor.brush {
	import com.fuelindustries.core.AssetProxy;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.AbstractBrushVO;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class AbstractBrush extends AbstractActor {
		
		protected static var BRUSH_UID:int = 0;
		
		protected var __topLeft:Point;
		protected var __topRight:Point;
		protected var __bottomRight:Point;
		protected var __bottomLeft:Point;
		
		protected var __subDFirst:Point;
		protected var __subDSecond:Point;
		protected var __subDPercentage:Number;
		protected var __subDValue:Number;
		
		protected var __id:int;
		protected var __stringName:String;
		
		protected var __outlineColor:Number;
		protected var __outlineAlpha:Number;
		protected var __fillColor:Number;
		protected var __fillAlpha:Number;
		
		protected var __activated:Boolean;
		protected var __selected:Boolean;
		
		
		protected var __overColorTransform:ColorTransform;
		protected var __normalColorTransform:ColorTransform;
		protected var __selectedColorTransform:ColorTransform;
		
		public function AbstractBrush() {
			linkage = AssetProxy.BLANK_MOVIECLIP;
			init();
		}
		
		protected function init():void {
			
			__id = BRUSH_UID;
			__stringName = "Planar Brush " + __id;
			BRUSH_UID++;
			
			__activated = false;
			
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			setupColorTransforms();
			__dataVO["subDivisionsX"] = 1;
			__dataVO["subDivisionsY"] = 1;
		}
		

		override protected function setupData() : void {
			__dataVO = new AbstractBrushVO();
		}

		override protected function setupBindings() : void {
			super.setupBindings();
			
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
		
		
		//Renders the Brush
		public function render():void	{
			
			
			var g:Graphics = this.graphics;
			
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
			
			
		}
		
		public function get activated() : Boolean {
			return __activated;
		}
		
		public function set activated(_activated : Boolean) : void {
			if (__activated != _activated) {
				__activated = _activated;
				if (__activated == true) {
					this.useHandCursor = true;
					this.buttonMode = true;
					this.addEventListener(MouseEvent.MOUSE_OVER, onMOver);
					this.addEventListener(MouseEvent.MOUSE_OUT, onMOut);
				}
				else {
					this.useHandCursor = false;
					this.buttonMode = false;
					this.removeEventListener(MouseEvent.MOUSE_OVER, onMOver);
					this.removeEventListener(MouseEvent.MOUSE_OUT, onMOut);
				}
			}
		}
		
		
		public function get selected() : Boolean {
			return __selected;
		}
		
		public function set selected(_selected : Boolean) : void {
			if (__selected != _selected) {
				__selected = _selected;
				if (__selected) {
					this.transform.colorTransform = __selectedColorTransform;
				}
				else {
					this.transform.colorTransform = __normalColorTransform;
				}
			}
		}
		
		
		
		
		public function get stringName() : String {
			return __stringName;
		}
		
		public function get id() : int {
			return __id;
		}
		
		private function get dataRef() : AbstractBrushVO {
			return __dataVO as AbstractBrushVO;
		}
		
		//INTERACTION HANDLERS
		
		protected function onMDown(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
		}
		protected function onMUp(e:MouseEvent):void {
			e.stopImmediatePropagation();
			this.dispatchEvent(new ActorEvent(ActorEvent.ACTOR_SELECTED, this));
		}
		
		protected function onMOver(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __overColorTransform;
			}
		}
		protected function onMOut(e:MouseEvent):void {
			e.stopImmediatePropagation();
			if (!__selected) {
				this.transform.colorTransform = __normalColorTransform;
			}
		}

		override public function destroy() : void {
			__topLeft = null;
			__topRight = null;
			__bottomRight = null;
			__bottomLeft = null;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
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