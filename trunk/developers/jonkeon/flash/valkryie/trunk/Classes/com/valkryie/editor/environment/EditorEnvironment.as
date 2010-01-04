package com.valkryie.editor.environment {
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.editor.GridVO;
	import com.valkryie.editor.brush.AdditiveBrush;
	import com.valkryie.editor.brush.BuilderBrush;
	import com.valkryie.editor.elements.editor_top_panel.events.EditorModeEvent;
	import com.valkryie.editor.events.EditorActionEvent;
	import com.valkryie.editor.events.EditorToolSelectEvent;
	import com.valkryie.editor.grid.IsoGrid;
	import com.valkryie.editor.statics.EditorStatics;
	import com.valkryie.editor.statics.ToolStatics;
	import com.valkryie.environment.AbstractEnvironment;
	import com.valkryie.environment.geometric.statics.IsoStatics;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author jkeon
	 */
	public class EditorEnvironment extends AbstractEnvironment {
		
		//What are we doing currently
		protected var __draggingActor:Boolean;
		protected var __scalingActor:Boolean;
		
		//The Builder Brush
		protected var __builderBrush:BuilderBrush;
		
		
		//Point used for converting ISO coordinates into Screen Space
		protected var __screenPoint:Point;
		
		
		protected var __activeTool:String;
		
		
		
		protected var __actorDragOffsetX:int;
		protected var __actorDragOffsetY:int;
		
		
		protected var __gridMap:IsoGrid;
		protected var __gridSnapping:Boolean;
		
		
		protected var __bindings:Array;
		
		
		protected var __editorMode:String;
		
		public function EditorEnvironment() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			__bindings = [];
			
			__draggingActor = false;
			__scalingActor = false;
			
			__builderBrush = new BuilderBrush();
			__builderBrush.linkDisplay();
		
			__gridMap = new IsoGrid();
			__gridMap.linkDisplay();
			__canvas.addChild(__gridMap.display);
			
			__editorMode = EditorStatics.EDITOR_MODE_BRUSH;
			
			Subscriber.subscribe(EditorToolSelectEvent.TOOL_CHANGE, onToolChange);
			Subscriber.subscribe(EditorActionEvent.CREATE_ADDITIVE_BRUSH, createAdditiveBrush);
			Subscriber.subscribe(ActorEvent.ACTOR_SELECTED, onActorSelected);
			Subscriber.subscribe(EditorModeEvent.EDITOR_MODE_CHANGE, onModeChange);
		}

		override protected function onAdded() : void {
			super.onAdded();
			__builderBrush.dataVO["isoWidth"] = 256;
			__builderBrush.dataVO["isoDepth"] = 256;
			__builderBrush.dataVO["isoX"] = int(IsoStatics.GRID_WIDTH/2) - int(__builderBrush.dataVO["isoWidth"]/2);
			__builderBrush.dataVO["isoY"] = int(IsoStatics.GRID_DEPTH/2) - int(__builderBrush.dataVO["isoDepth"]/2);
			
			__canvas.addBrush(__builderBrush, __editorMode == EditorStatics.EDITOR_MODE_BRUSH);
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
			//TODO: Anything here?
		}
		
		protected function onModeChange(e:EditorModeEvent):void {
			deactivateMode();
			__editorMode = e.mode;
			activateMode();
		}
		
		protected function deactivateMode():void {
			switch (__editorMode) {
				case EditorStatics.EDITOR_MODE_BRUSH:
					__canvas.hideBrushes();
				break;
				case EditorStatics.EDITOR_MODE_VERTEX:
					__canvas.hideVertices();
				break;
			}
		}
		
		protected function activateMode():void {
			switch (__editorMode) {
				case EditorStatics.EDITOR_MODE_BRUSH:
					__canvas.showBrushes();
				break;
				case EditorStatics.EDITOR_MODE_VERTEX:
					__canvas.showVertices();
				break;
			}
		}
		
		protected function onActorSelected(e:ActorEvent):void {
			if (__selectedActor != null) {
				__selectedActor.selected = false;
			}
			__selectedActor = e.actor;
			if (__selectedActor != null) {
				__selectedActor.selected = true;
			}
		}

		
		protected override function onMouseDown(e : MouseEvent) : void {
			calculatePickingPoint();
		
			//Based on the active tool, we want to take action 
			switch (__activeTool) {
				case ToolStatics.TOOL_MOVE:
					handleMove();
				break;
				case ToolStatics.TOOL_SCALE:
					handleScale();
				break;
			}

		}
		
		
		protected override function onMouseUp(e:Event):void {
			calculatePickingPoint();
			
			__draggingActor = false;
			__scalingActor = false;
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		
		protected function handleMove():void {
			
			snapToGrid(__pickingPoint);
			//If we selected a Brush
			if (__selectedActor != null) {
				
				__draggingActor = true;
				__actorDragOffsetX = __selectedActor.dataVO["isoX"] - __pickingPoint.x;
				__actorDragOffsetY = __selectedActor.dataVO["isoY"] - __pickingPoint.y;
			}
			this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		protected function handleScale():void {
			snapToGrid(__pickingPoint);
			
			//If we selected a Brush
			if (__selectedActor != null) {
				__scalingActor = true;
			}
			this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		
	

		override protected function onTick(e : Event) : void {
			
			if (__selectedActor != null) {
				if (__draggingActor) {
					//TODO Fix to axis
					__screenPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
					snapToGrid(__screenPoint);
					__selectedActor.dataVO["isoX"] = __screenPoint.x + __actorDragOffsetX;
					__selectedActor.dataVO["isoY"] = __screenPoint.y + __actorDragOffsetY;
				}
				
				if (__scalingActor) {
					__screenPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
					snapToGrid(__screenPoint);
					__selectedActor.dataVO["isoWidth"] = __screenPoint.x - __selectedActor.dataVO["isoX"];
					__selectedActor.dataVO["isoDepth"] = __screenPoint.y - __selectedActor.dataVO["isoY"];
					__selectedActor.render();	
				}
			}
			
			
			super.onTick(e);
		}
		
		protected function onToolChange(e:EditorToolSelectEvent):void {
			cleanActiveTool();
			__activeTool = e.tool;
			setupActiveTool();
		}
		
		protected function cleanActiveTool():void {
			//based on the tool, clean it up
		}
		
		protected function setupActiveTool():void {
			//based on the tool, setup the tool
		}
		
		
		
		protected function createAdditiveBrush(e:EditorActionEvent):void {
			if (__builderBrush != null) {
				//TODO: Add Added Brush
				var newBrush:AdditiveBrush = new AdditiveBrush();
				newBrush.linkDisplay();
				newBrush.dataVO["isoX"] = __builderBrush.dataVO["isoX"];
				newBrush.dataVO["isoY"] = __builderBrush.dataVO["isoY"];
				newBrush.dataVO["isoWidth"] = __builderBrush.dataVO["isoWidth"];
				newBrush.dataVO["isoDepth"] = __builderBrush.dataVO["isoDepth"];
				newBrush.dataVO["subDivisionsX"] = __builderBrush.dataVO["subDivisionsX"];
				newBrush.dataVO["subDivisionsY"] = __builderBrush.dataVO["subDivisionsY"];
				
				__canvas.addBrush(newBrush, __editorMode == EditorStatics.EDITOR_MODE_BRUSH);
				__canvas.convertBrushToPoly(newBrush, __editorMode == EditorStatics.EDITOR_MODE_VERTEX);
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
