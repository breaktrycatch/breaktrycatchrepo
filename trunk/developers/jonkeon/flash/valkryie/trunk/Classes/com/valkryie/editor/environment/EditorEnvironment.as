package com.valkryie.editor.environment {
	import com.module_subscriber.core.Subscriber;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.actor.events.ActorEvent;
	import com.valkryie.data.vo.GridVO;
	import com.valkryie.editor.brush.AbstractBrush;
	import com.valkryie.editor.brush.AdditiveBrush;
	import com.valkryie.editor.brush.BuilderBrush;
	import com.valkryie.editor.events.EditorToolSelectEvent;
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
			__activeBrush = __builderBrush;
		
			__gridMap = new IsoGrid();
			__gridMap.linkDisplay();
			__canvas.addChild(__gridMap.display);
			
			Subscriber.subscribe(EditorToolSelectEvent.TOOL_CHANGE, onToolChange);
		}

		override protected function onAdded() : void {
			super.onAdded();
			__builderBrush.dataVO["isoWidth"] = 256;
			__builderBrush.dataVO["isoDepth"] = 256;
			__builderBrush.dataVO["isoX"] = int(IsoStatics.GRID_WIDTH/2) - int(__builderBrush.dataVO["isoWidth"]/2);
			__builderBrush.dataVO["isoY"] = int(IsoStatics.GRID_DEPTH/2) - int(__builderBrush.dataVO["isoDepth"]/2);
			
			addBrush(__builderBrush);
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
		
		
		protected function determinePickedActor(_actorType:String):void {
			for (var i:int = 0; i < __brushes.length; i++) {
				__pickingCheckBrush = __brushes[i] as AbstractBrush;
				__pickingCheckIsoBounds = __pickingCheckBrush.dataVO["isoBounds"];
				if (__pickingCheckIsoBounds.containsPoint(__pickingPoint)) {
					assignPickedActor(__pickingCheckBrush, _actorType);
					return;	
				}
			}
			//TODO: Search Actors
			
			assignPickedActor(null, _actorType);
		}
		
		
		protected function assignPickedActor(_abstractActor:AbstractActor, _actorType:String):void {
			
			if (_actorType == QUEUED_PICKED_ACTOR) {
				//Assign the Mouse Down Actor
				__queuedPickedActor = _abstractActor;
				//If the currently Selected Actor is not the same as what we just clicked on...
				if (__selectedActor != __queuedPickedActor) {
					if (__selectedActor != null) {
						__selectedActor.selected = false;
					}
					__selectedActor = __queuedPickedActor;
					if (__selectedActor != null) {
						__selectedActor.selected = true;
					}
				}
			}
			else if (_actorType == ACTUAL_PICKED_ACTOR) {
				//Assign the Mouse Up Actor
				__actualPickedActor = _abstractActor;
//				//If it is the same actor we moused down on...
//				if (__actualPickedActor == __queuedPickedActor) {
//					//Set it to be the selected actor
//					__selectedActor = __actualPickedActor;
//					//It might be null, so only if not null...
//					if (__selectedActor != null) {
//						//assign it to be selected
//						__selectedActor.selected = true;
//					}
//				}
//				//If they're not the same
//				else {
//					//If the selected actor exists
//					if (__selectedActor != null) {
//						//assign it to be selected
//						__selectedActor.selected = false;
//						__selectedActor = null;
//					}
//				}
			}
		}

		
		protected override function onMouseDown(e : MouseEvent) : void {
			calculatePickingPoint();
			determinePickedActor(QUEUED_PICKED_ACTOR);
			Subscriber.issue(new ActorEvent(ActorEvent.ACTOR_SELECTED, __selectedActor));
		
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
			determinePickedActor(ACTUAL_PICKED_ACTOR);
			//dispatchEvent(new ActorEvent(ActorEvent.ACTOR_SELECTED, __selectedActor));
			
			__drawingBrush = false;
			__draggingBrush = false;
			__scalingBrush = false;
			this.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		
		protected function handleMove():void {
			
			snapToGrid(__pickingPoint);
			
			//If we selected a Brush
			if (__selectedActor is AbstractBrush) {
				
				__activeBrush = (__selectedActor as AbstractBrush);
				
				__draggingBrush = true;
				__brushDragOffsetX = __activeBrush.dataVO["isoX"] - __pickingPoint.x;
				__brushDragOffsetY = __activeBrush.dataVO["isoY"] - __pickingPoint.y;
			}
			this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		protected function handleScale():void {
			snapToGrid(__pickingPoint);
			
			//If we selected a Brush
			if (__selectedActor is AbstractBrush) {
				
				__activeBrush = (__selectedActor as AbstractBrush);
				
				__scalingBrush = true;
			}
			this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		protected function addBrush(_brush:AbstractBrush):void {
			__brushes.push(_brush);
			
			//Ensure Builder Brush is always on top
			if (_brush != __builderBrush && __builderBrush.parent == __brushMap) {
				var depth:int = __brushMap.getChildIndex(__builderBrush.display);
				__brushMap.addChildAt(_brush.display, depth);
			}
			else {
				__brushMap.addChild(_brush.display);
			}
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
		
		
		
		public function createAdditiveBrush():void {
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
				
				addBrush(newBrush);
				//TODO: Enable to allow actual polygons to be added
				//__canvas.addPlane(newBrush);
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
