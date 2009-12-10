package com.valkryie.editor.environment {
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.GridVO;
	import com.valkryie.editor.brush.AbstractBrush;
	import com.valkryie.editor.brush.BuilderBrush;
	import com.valkryie.editor.grid.IsoGrid;
	import com.valkryie.editor.statics.ToolStatics;
	import com.valkryie.environment.AbstractEnvironment;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class EditorEnvironment extends AbstractEnvironment {
		
		
		protected var __drawingBrush:Boolean;
		protected var __draggingBrush:Boolean;
		protected var __scalingBrush:Boolean;
		
		protected var __activeBrush:AbstractBrush;
		protected var __pickingCheckBrush:AbstractBrush;
		protected var __pickingCheckIsoBounds:Rectangle;
		protected var __builderBrush:BuilderBrush;
		
		protected var __brushMap:MovieClip;
		
		protected var __screenPoint:Point;
		
		protected var __activeTool:String;
		protected var __activeSubTool:String;	
		
		
		protected var __brushes:Array;
		protected var __brushesActivated:Boolean;
		
		protected var __brushDragOffsetX:int;
		protected var __brushDragOffsetY:int;
		
		
		protected var __gridMap:IsoGrid;
		protected var __gridSnapping:Boolean;
		
		
		protected var __bindings:Array;
		
		public function EditorEnvironment() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__bindings = [];
			
			__brushes = [];
			__brushesActivated = false;
			
			__drawingBrush = false;
			__draggingBrush = false;
			__scalingBrush = false;
			
			__brushMap = new MovieClip();
			__canvas.addChild(__brushMap);
			
			__builderBrush = new BuilderBrush();
			__builderBrush.linkDisplay();
			addBrush(__builderBrush);
			__activeBrush = __builderBrush;
		
			__gridMap = new IsoGrid();
			__gridMap.linkDisplay();
			__canvas.addChild(__gridMap.display);
			
			
		}
		
		public function setGridData(_gridData:GridVO):void {
			__gridMap.gridData = _gridData;
			__gridMap.render();
	
			__bindings.push(__gridMap.gridData.bind("snap", this, toggleGridSnap));
			__bindings.push(__gridMap.gridData.bind("layer", this, toggleGridLayer));
			
			toggleGridSnap();
			toggleGridLayer();
		}
		
		
		protected function toggleGridSnap():void {
			__gridSnapping = __gridMap.gridData.snap;
		}
		
		protected function toggleGridLayer():void {
			if (__gridMap.gridData.layer == GridVO.GRID_LAYER_BOTTOM) {
				__canvas.setChildIndex(__gridMap.display, 0);
			}
			else {
				__canvas.setChildIndex(__gridMap.display, __canvas.numChildren - 1);
			}
		}

		override protected function updateScreenCoordinates() : void {
			super.updateScreenCoordinates();
			if (__activeBrush != null) {
				__activeBrush.render();
			}
		}

		
		override protected function getPickedActor() : void {
			super.getPickedActor();
			
			for (var i:int = 0; i < __brushes.length; i++) {
				__pickingCheckBrush = __brushes[i] as AbstractBrush;
				__pickingCheckIsoBounds = __pickingCheckBrush.dataVO["isoBounds"];
				if (__pickingCheckIsoBounds.containsPoint(__pickingPoint)) {
					__pickedActor = __pickingCheckBrush;
					return;	
				}
			}
			
			//TODO: Search Actors
			
			__pickedActor = null;
		}

		
		protected override function onMouseDown(e : MouseEvent) : void {
			
			super.onMouseDown(e);
			dtrace("Picked Actor " + __pickedActor);
			dispatchEvent(new ActorEvent(ActorEvent.ACTOR_SELECTED, __pickedActor));
			
			//Based on the active tool, we want to take action 
			switch (__activeTool) {
				
				case ToolStatics.TOOL_SELECT_BRUSHES:
					handleBrushes();
				break;
				
				
			}

		}
		
		protected function onMouseUp(e:Event):void {
			__drawingBrush = false;
			__draggingBrush = false;
			__scalingBrush = false;
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		
		protected function handleBrushes():void {
			
			snapToGrid(__pickingPoint);
			
			//If we selected a Brush
			if (__pickedActor is AbstractBrush) {
				
				__activeBrush = (__pickedActor as AbstractBrush);
				
				switch (__activeSubTool) {
					case ToolStatics.TOOL_MOVE:
						__draggingBrush = true;
						__brushDragOffsetX = __activeBrush.dataVO["isoX"] - __pickingPoint.x;
						__brushDragOffsetY = __activeBrush.dataVO["isoY"] - __pickingPoint.y;
					break;
					case ToolStatics.TOOL_SCALE:
						__scalingBrush = true;
					break;
				}
				
			}
			//Otherwise we're on open land
			else {
				__drawingBrush = true;
				__activeBrush.dataVO["isoX"] = __pickingPoint.x;
				__activeBrush.dataVO["isoY"] = __pickingPoint.y;
			}
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		protected function addBrush(_brush:AbstractBrush):void {
			__brushes.push(_brush);
			__brushMap.addChild(_brush.display);
		}
		
		protected function removeBrush(_brush:AbstractBrush):void {
			var index:int = __brushes.indexOf(_brush);
			if (index != -1) {
				__brushMap.removeChild(_brush.display);
				__brushes.splice(index, 1);
			}
		}
	

		override protected function onTick(e : Event) : void {
			
			if (__drawingBrush) {
				__screenPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
				snapToGrid(__screenPoint);
				__activeBrush.dataVO["isoWidth"] = __screenPoint.x - __activeBrush.dataVO["isoX"];
				__activeBrush.dataVO["isoDepth"] = __screenPoint.y - __activeBrush.dataVO["isoY"];
				__activeBrush.render();	
			}
			
			if (__draggingBrush) {
				//TODO Fix to axis
				__screenPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
				snapToGrid(__screenPoint);
				__activeBrush.dataVO["isoX"] = __screenPoint.x + __brushDragOffsetX;
				__activeBrush.dataVO["isoY"] = __screenPoint.y + __brushDragOffsetY;
			}
			
			if (__scalingBrush) {
				__screenPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
				snapToGrid(__screenPoint);
				__activeBrush.dataVO["isoWidth"] = __screenPoint.x - __activeBrush.dataVO["isoX"];
				__activeBrush.dataVO["isoDepth"] = __screenPoint.y - __activeBrush.dataVO["isoY"];
				__activeBrush.render();	
			}
			
			
			super.onTick(e);
		}
		
		public function get activeTool() : String {
			return __activeTool;
		}
		
		public function set activeTool(_activeTool : String) : void {
			__activeTool = _activeTool;
			dtrace("AT SET");
		}
		
		public function get activeSubTool() : String {
			return __activeSubTool;
		}
		
		public function set activeSubTool(_activeSubTool : String) : void {
			dtrace("AST SET");
			__activeSubTool = _activeSubTool;
			handleTools();
		}
		
		protected function handleTools():void {
			if (__activeTool == ToolStatics.TOOL_SELECT_BRUSHES) {
				setBrushActivation(true);
			}
			else {
				setBrushActivation(false);
			}
		}
		
		protected function setBrushActivation(_bool:Boolean):void {
			
			if (__brushesActivated != _bool) {
				__brushesActivated = _bool;
				var brush:AbstractBrush;
				for (var i:int = 0; i<__brushes.length; i++) {
					brush = __brushes[i];
					brush.activated = _bool;
				}
			}
		}
		
		
		public function addActiveBrush():void {
			dtrace(__activeBrush);
			if (__activeBrush != null) {
				//TODO: Add Added Brush
				__canvas.addPlane(__activeBrush);
			}
		}
		
		
		
		protected function snapToGrid(_point:Point):void {
			if (__gridSnapping) {
				_point.x = Math.round(_point.x/__gridMap.gridData.spacingWidth) * __gridMap.gridData.spacingWidth;
				_point.y = Math.round(_point.y/__gridMap.gridData.spacingDepth) * __gridMap.gridData.spacingDepth;
			}
		}
	}
}
