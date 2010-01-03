package com.valkryie.editor.grid {
	import com.fuelindustries.core.AssetProxy;
	import com.fuelindustries.core.FuelUI;
	import com.valkryie.data.vo.editor.GridVO;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class IsoGrid extends FuelUI {
		
		protected var __gridData:GridVO;
		
		
		protected var __subWidth:int;
		protected var __subDepth:int;
		
		protected var __gridWidth:int;
		protected var __gridDepth:int;
		
		protected var __subDivX:int;
		protected var __subDivY:int;
		
		protected var __subDPer:Number;
		protected var __subDValue:Number;
		
		protected var __subDFirst:Point;
		protected var __subDSecond:Point;
		
		protected var __graphics:Graphics;
		
		
		protected var __bindings:Array;
		
		
		public function IsoGrid() {
			super();
			linkage = AssetProxy.BLANK_MOVIECLIP;
		}
		
		public function get gridData() : GridVO {
			return __gridData;
		}
		
		public function set gridData(_gridData : GridVO) : void {
			__gridData = _gridData;
			__bindings = [];
			
			__bindings.push(__gridData.bind("spacingWidth", this, render));
			__bindings.push(__gridData.bind("spacingDepth", this, render));
			__bindings.push(__gridData.bind("shown", this, handleShown));
			
			handleShown();
		}
		
		protected function handleShown():void {
			this.visible = __gridData.shown;
		}
		
		public function render():void {
			
			__subWidth = __gridData.spacingWidth;
			__subDepth = __gridData.spacingDepth;
			
			__gridWidth = IsoStatics.GRID_WIDTH;
			__gridDepth = IsoStatics.GRID_DEPTH;
			
			__subDivX = __gridWidth/__subWidth;
			__subDivY = __gridDepth/__subDepth;
			
			__graphics = this.graphics;
			__graphics.clear();
			__graphics.lineStyle(1, 0x333333);
			
			//Draw the Subdivisions
			for(var x:int = 1; x < __subDivX; x++) {
			
				__subDPer = x/__subDivX;
				__subDValue = __subDPer*__gridWidth;
				
				__subDFirst = IsoStatics.worldToScreen(__subDValue, 0, 0);
				__subDSecond = IsoStatics.worldToScreen(__subDValue, __gridDepth, 0);
				
				__graphics.moveTo(__subDFirst.x, __subDFirst.y);
				__graphics.lineTo(__subDSecond.x, __subDSecond.y);
			}
			
			for(var y:int = 1; y < __subDivY; y++) {
			
				__subDPer = y/__subDivY;
				__subDValue = __subDPer*__gridDepth;
				
				__subDFirst = IsoStatics.worldToScreen(0, __subDValue, 0);
				__subDSecond = IsoStatics.worldToScreen(__gridWidth, __subDValue, 0);
				
				__graphics.moveTo(__subDFirst.x, __subDFirst.y);
				__graphics.lineTo(__subDSecond.x, __subDSecond.y);
			}
		}
	}
}
