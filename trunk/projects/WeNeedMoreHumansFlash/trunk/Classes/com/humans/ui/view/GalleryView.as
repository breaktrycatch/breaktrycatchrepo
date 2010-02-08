package com.humans.ui.view {
	import caurina.transitions.Tweener;

	import com.humans.buildings.BuildingFactory;
	import com.humans.buildings.BuildingPlane;
	import com.humans.buildings.events.BuildingClickedEvent;
	import com.humans.buildings.events.BuildingCreatedEvent;
	import com.humans.data.statics.ProjectStatics;
	import com.module_keyinput.core.InputManager;
	import com.module_subscriber.core.Subscriber;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.clipping.FrustumClipping;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	import flash.events.Event;

	/**
	 * @author jkeon
	 */
	public class GalleryView extends BaseView {
		
		
		protected var __viewport:Viewport3D;
		protected var __camera:Camera3D;
		protected var __renderer:BasicRenderEngine;
		protected var __scene:Scene3D;
		
		
		protected var __rendering:Boolean;
		
		protected var __moveAmount:int;
		
		protected var __light:PointLight3D;
		
		protected var __world:DisplayObject3D;
		
		
		
		protected var __buildings:Array;
		
		
		public function GalleryView() {
			super();
			linkage = "GalleryView_mc";
		}

		
		override protected function completeConstruction() : void {
			super.completeConstruction();
			__rendering = false;
			
			
			__moveAmount = 10;
			
			__buildings = [];
			
			
			__viewport = new Viewport3D(760,500,false,true,true,true);
			__camera = new Camera3D(60,0.1,5000,true,true);
			
			__scene = new Scene3D();
			
			__renderer = new BasicRenderEngine();
			__renderer.clipping = new FrustumClipping(FrustumClipping.ALL);
			
			__light = new PointLight3D(true);
			
			
			setup();
			
			startRendering();
		}
		
		protected function setup():void {
			
			addChild(__viewport);
			
			
			InputManager.getInstance().mapFunction(InputManager.KEY_UPARROW, moveCamera, [0, 1], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_DOWNARROW, moveCamera, [0, -1], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_RIGHTARROW, moveCamera, [1, 0], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_LEFTARROW, moveCamera, [-1, 0], true);
			
			InputManager.getInstance().mapFunction(InputManager.KEY_Q, adjustCameraFocus, [-1], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_W, adjustCameraFocus, [1], true);
			
			InputManager.getInstance().mapFunction(InputManager.KEY_A, adjustCameraZoom, [-1], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_S, adjustCameraZoom, [1], true);
			
			InputManager.getInstance().mapFunction(InputManager.KEY_O, adjustCameraPitch, [-1], true);
			InputManager.getInstance().mapFunction(InputManager.KEY_P, adjustCameraPitch, [1], true);
			
			
			__light.y = 5000;
			__camera.z = 0;
			__camera.y = -200;
			
			
			__world = new DisplayObject3D();
			__scene.addChild(__world);			
			
			var image:int;
			var path:String;
			
			Subscriber.subscribe(BuildingCreatedEvent.BUILDING_CREATED, onBuildingCreated);
			Subscriber.subscribe(BuildingClickedEvent.BUILDING_CLICKED, onBuildingClick);
			
			for (var i:int = 0; i < 100; i++) {
				image = Math.floor(Math.random() * 5) + 1;
				path = ProjectStatics.getStatic( "image_url") + "b0" + image + ".png";
				BuildingFactory.getInstance().createBuilding(path);
			}
			
			
			
			__world.addChild(__light);
			
		}
		
		protected function onBuildingCreated(e:BuildingCreatedEvent):void {
			var bp:BuildingPlane = e.building;
			bp.x = Math.floor(Math.random() * 6000) - 3000;
			bp.z = Math.floor(Math.random() * 3000);
		
			__buildings.push(bp);
			__world.addChild(bp);
		}
		
		protected function onBuildingClick(e:BuildingClickedEvent):void {
			var bp:BuildingPlane = e.building;
			
			dtrace("FOV " + __camera.fov);
			
			var upperBound:Number;
			var distance:int = 200;
			
			upperBound = -(distance * (Math.tan(__camera.fov)));
			
			var target:Number = bp.mc.height + 25;
			var targetAngle:Number = Math.atan(target/200) * (180/3.14);
			
			var deltaAngle:Number = -(targetAngle - (__camera.fov/2));
			
			dtrace("UpperBound " + upperBound);
			dtrace("BP Height " + bp.mc.height);
			dtrace("TargetAngle " + targetAngle);
			
			//Debug Spheres to show upper bounds of the viewport
//			var sphere:Sphere = new Sphere(new ColorMaterial(), 25);
//			sphere.y = upperBound;
//			sphere.z = bp.z;
//			sphere.x = bp.x;
//			
//			var sphere2:Sphere = new Sphere(new ColorMaterial(), 25);
//			sphere2.y = target;
//			sphere2.z = bp.z;
//			sphere2.x = bp.x;
//			
//			__scene.addChild(sphere);
//			__scene.addChild(sphere2);
			
			Tweener.addTween(__camera, {rotationX:0, time:1.5, transition:"easeinoutquad", onComplete:lookUp, onCompleteParams:[deltaAngle]});
			
			Tweener.addTween(__camera, {x:bp.x, z:bp.z - 200, time:3.0, transition:"easeinoutexpo"});
			
		}
		
		protected function lookUp(_deltaAngle:Number):void {
			Tweener.addTween(__camera, {rotationX:_deltaAngle, time:1.5, transition:"easeoutquad"});
		}

		
		protected function moveCamera(_x:int, _z:int):void {
			__camera.x += (_x * __moveAmount);
			__camera.z += (_z * __moveAmount);
			dtrace("POS " + __camera.x, __camera.y, __camera.z);
		}
		
		protected function adjustCameraFocus(_amount:int):void {
			__camera.focus += _amount;
			dtrace("FOCUS " + __camera.focus);
		}
		protected function adjustCameraZoom(_amount:int):void {
			__camera.zoom += _amount;
			dtrace("ZOOM " + __camera.zoom);
		}
		protected function adjustCameraPitch(_amount:int):void {
			__camera.rotationX += _amount;
			dtrace("PITCH " + __camera.rotationX);
		}

		
		protected function startRendering():void {
			__rendering = true;
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function stopRendering():void {
			__rendering = false;
			removeEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function onRender(e:Event):void {
			if (__rendering) {
				
				var bp:BuildingPlane;
				var distance:Number;
				for(var i:int = 0; i < __buildings.length; i++) {
					bp = __buildings[i] as BuildingPlane;
					distance = bp.z - __camera.z;
					
					bp.y = -((distance/2));
						
					
				}
				
				
				
				__renderer.renderScene(__scene, __camera, __viewport);
			}
		}

	}
}
