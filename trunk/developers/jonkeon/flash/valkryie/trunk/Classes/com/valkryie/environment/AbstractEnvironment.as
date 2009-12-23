package com.valkryie.environment {
	import com.fuelindustries.core.FuelUI;
	import com.fuelindustries.tween.TweenEnterFrame;
	import com.module_keyinput.core.InputManager;
	import com.valkryie.actor.AbstractActor;
	import com.valkryie.data.vo.CameraVO;
	import com.valkryie.data.vo.LevelVO;
	import com.valkryie.environment.camera.IsoCamera;
	import com.valkryie.environment.geometric.statics.IsoStatics;
	import com.valkryie.environment.render.IsoCanvas;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class AbstractEnvironment extends FuelUI {
		
		//What the World is drawn onto
		protected var __canvas:IsoCanvas;
		protected var __screenDebug:MovieClip;
		//Camera Position in the World (Arbitrary)
		protected var __camera:IsoCamera;
		
		protected var __cameraMovementX:Number = 0;
		protected var __cameraMovementY:Number = 0;
		protected var __cameraNeedToUpdate:Boolean;
		
		protected var __levelVO:LevelVO;
	
	
		public static var FLAG_DEBUG_CAMERA_VIEWABLE_AREA:Boolean = true;
		
		protected var __queuedPickedActor:AbstractActor;
		protected var __actualPickedActor:AbstractActor;
		protected var __selectedActor:AbstractActor;
		protected var __pickingPoint:Point;
		
		protected const QUEUED_PICKED_ACTOR:String = "queued_picked_actor";
		protected const ACTUAL_PICKED_ACTOR:String = "actual_picked_actor";
	
	
		public function AbstractEnvironment() {
			super();
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
		
			//Create a camera
			__camera = new IsoCamera();
			
			//Attach the Canvas
			__canvas = new IsoCanvas(__camera);
			this.addChild(__canvas);
			
			//Attach the Screen Debug (will not move when the canvas moves)
			__screenDebug = new MovieClip();
			this.addChild(__screenDebug);

		}
		
		
		public function applyLevelData(_levelVO:LevelVO):void {
			__levelVO = _levelVO;
			
			var cameraVO:CameraVO = __levelVO.cameraData;
			
			
			//Assign the Viewable Area
			__camera.setViewableArea(new Rectangle(cameraVO.cameraViewSpaceX, cameraVO.cameraViewSpaceY, cameraVO.cameraViewSpaceWidth, cameraVO.cameraViewSpaceHeight));
			
			//Debug Viewable Area
			if (FLAG_DEBUG_CAMERA_VIEWABLE_AREA) {
				debugCameraViewableArea();
			}
			
			//Define Camera Rotation
			IsoCamera.location = cameraVO.cameraLocation;
			
			//Define Grid Width and Height
			IsoStatics.GRID_WIDTH = __levelVO.levelIsoWidth;
			IsoStatics.GRID_DEPTH = __levelVO.levelIsoDepth;
			//Define Camera Start X and Y
			if (cameraVO.cameraStartIsoX != -1) {
				IsoStatics.GRID_CENTER_X = cameraVO.cameraStartIsoX;
			}
			else {
				IsoStatics.GRID_CENTER_X = IsoStatics.GRID_WIDTH/2;
			}
			if (cameraVO.cameraStartIsoY != -1) {
				IsoStatics.GRID_CENTER_Y = cameraVO.cameraStartIsoY;
			}
			else {
				IsoStatics.GRID_CENTER_Y = IsoStatics.GRID_DEPTH/2;
			}
			//Create the Grid
			defineGrid();
			
			//Handle First Run
			firstRun();
		}

		//Creates the Initial ISO Blank World
		protected function defineGrid():void {
			
			var v1x:Number = IsoStatics.GRID_X;
			var v1y:Number = IsoStatics.GRID_Y;
			
			var v2x:Number = IsoStatics.GRID_X + IsoStatics.GRID_WIDTH;
			var v2y:Number = IsoStatics.GRID_Y;
			
			var v3x:Number = IsoStatics.GRID_X + IsoStatics.GRID_WIDTH;
			var v3y:Number = IsoStatics.GRID_Y + IsoStatics.GRID_DEPTH;
			
			var v4x:Number = IsoStatics.GRID_X;
			var v4y:Number = IsoStatics.GRID_Y + IsoStatics.GRID_DEPTH;
			
			var s1x:Number = v1x - v1y;
			var s1y:Number = (v1x + v1y)*0.5;
			
			var s2x:Number = v2x - v2y;
			var s2y:Number = (v2x + v2y)*0.5;
			
			var s3x:Number = v3x - v3y;
			var s3y:Number = (v3x + v3y)*0.5;
			
			var s4x:Number = v4x - v4y;
			var s4y:Number = (v4x + v4y)*0.5;
			
			IsoStatics.WORLD_OFFSET_X = -s4x;
			IsoStatics.WORLD_OFFSET_Y = s3y;

			__camera.isoX = IsoStatics.GRID_CENTER_X;
			__camera.isoY = IsoStatics.GRID_CENTER_Y;
			
			var g:Graphics = __canvas.graphics;
			g.beginFill(0xCCCCCC);
			g.moveTo(s1x - s4x, s1y);
			g.lineTo(s2x - s4x, s2y);
			g.lineTo(s3x - s4x, s3y);
			g.lineTo(s4x - s4x, s4y);
			g.endFill();
			
			
			updateCameraPosition();
			updateCameraMovementVectors();
		}
		
		protected function firstRun():void {
			//Handle Input
			InputManager.getInstance().mapFunction(InputManager.KEY_LEFTARROW, rotateCameraLeft);
			InputManager.getInstance().mapFunction(InputManager.KEY_RIGHTARROW, rotateCameraRight);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			//We want the camera to update the first time we run this loop
			__cameraNeedToUpdate = true;
			TweenEnterFrame.addListener(onTick);
		}
		
		
		
		protected function onTick(e:Event):void {
			//LEFT
			if (this.mouseX < 50 && this.mouseX > 0) {
				__camera.isoX -= __cameraMovementX;
				__camera.isoY += __cameraMovementY;
				__cameraNeedToUpdate = true;
			}
			//RIGHT
			else if (this.mouseX > 710 && this.mouseX < 760) {
				__camera.isoX += __cameraMovementX;
				__camera.isoY -= __cameraMovementY;
				__cameraNeedToUpdate = true;
			}
			//UP
			if (this.mouseY < 50 && this.mouseY > 0) {
				__camera.isoY -= __cameraMovementX;
				__camera.isoX -= __cameraMovementY;
				__cameraNeedToUpdate = true;
			}
			//DOWN
			else if (this.mouseY > 450 && this.mouseY < 500) {
				__camera.isoY += __cameraMovementX;
				__camera.isoX += __cameraMovementY;
				__cameraNeedToUpdate = true;
			}
			
			if (__cameraNeedToUpdate) {
				updateCameraPosition();
				//Culls the actors out of the viewing pane
				__canvas.cullActors();
			}
			
		}
		

		public function renderGeometry():void {
			dtrace("Rendering Geometry");
			//__canvas.renderGeometry();
		}
		
		protected function updateScreenCoordinates():void {
			
			__canvas.clearDebug();
			__canvas.updateScreenCoordinates();
		}
		
		
		
		
		
		
		protected function onMouseDown(e:MouseEvent):void {
			//OVERRIDE
		}
		
		protected function onMouseUp(e:Event):void {
			//OVERRIDE
		}
		
		protected function calculatePickingPoint():void {
			__pickingPoint = IsoStatics.screenToWorld(__canvas.mouseX, __canvas.mouseY);
		}
		
		//Updates the Camera Position
		protected function updateCameraPosition():void {
			__cameraNeedToUpdate = false;
			__camera.calculateScreenCenter();
			
			//Move the canvas so it's centered in the camera
			__canvas.x = __camera.screenCenterPoint.x;
			__canvas.y = __camera.screenCenterPoint.y;
		}
		
		//Rotates the Camera to the Left
		protected function rotateCameraLeft():void {
			IsoCamera.location--;
			updateScreenCoordinates();
			updateCameraPosition();
			updateCameraMovementVectors();
		}
		
		//Rotates the Camera to the Right
		protected function rotateCameraRight():void {
			IsoCamera.location++;
			updateScreenCoordinates();
			updateCameraPosition();
			updateCameraMovementVectors();
		}
		
		//Handles the panning based on IsoCamera Rotation
		protected function updateCameraMovementVectors():void {
			var modX:int;
			var modY:int;
			
			if (IsoCamera.location == IsoCamera.LOC_SOUTH) {
				modX = 1;
				modY = 1;
			}
			else if (IsoCamera.location == IsoCamera.LOC_NORTH) {
				modX = -1;
				modY = -1;
			}
			else if (IsoCamera.location == IsoCamera.LOC_EAST) {
				modX = 1;
				modY = -1;
			}
			else if (IsoCamera.location == IsoCamera.LOC_WEST) {
				modX = -1;
				modY = 1;
			}
			
			__cameraMovementX = 2*modX;
			__cameraMovementY = 2*modY;
		}
		
		
		protected function debugCameraViewableArea():void {
			//Camera Viewing Area
			__screenDebug.graphics.lineStyle(3, 0xFF0000);
			__screenDebug.graphics.moveTo(__camera.viewableArea.left, __camera.viewableArea.top);
			__screenDebug.graphics.lineTo(__camera.viewableArea.right, __camera.viewableArea.top);
			__screenDebug.graphics.lineTo(__camera.viewableArea.right, __camera.viewableArea.bottom);
			__screenDebug.graphics.lineTo(__camera.viewableArea.left, __camera.viewableArea.bottom);
			__screenDebug.graphics.lineTo(__camera.viewableArea.left, __camera.viewableArea.top);
		}

	}
}
