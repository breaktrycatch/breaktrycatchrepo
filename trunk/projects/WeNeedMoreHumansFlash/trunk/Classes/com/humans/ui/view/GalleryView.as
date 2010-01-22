package com.humans.ui.view {
	import com.module_keyinput.core.InputManager;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
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
		
		
		protected var __worldGroup:DisplayObject3D;
		
		protected var __sphere:Sphere;
		protected var __plane:Plane;
		protected var __light:PointLight3D;
		
		
		public function GalleryView() {
			super();
			linkage = "GalleryView_mc";
		}

		
		override protected function completeConstruction() : void {
			super.completeConstruction();
			__rendering = false;
			
			
			__moveAmount = 10;
			
			
			__viewport = new Viewport3D(760,500,false,true,true,true);
			__camera = new Camera3D(60,1,5000,true,true);
			
			__scene = new Scene3D();
			
			__renderer = new BasicRenderEngine();
			
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
			
			
			var groundShader:FlatShadeMaterial = new FlatShadeMaterial(__light, 0x007700, 0x000000);
			
			
			__sphere = new Sphere(groundShader, 800, 8, 8);
			__sphere.roll(90);
			__sphere.scaleY = 4;
			
			__plane = new Plane(new ColorMaterial(0xFF0000, 1), 1000, 3000);
			var plane2:Plane = new Plane(new ColorMaterial(0xFFFF00, 1), 1000, 3000);
			var plane3:Plane = new Plane(new ColorMaterial(0xFF00FF, 1), 1000, 3000);
			
			__plane.y = 0;
			plane2.y = 1800;
			plane2.x = 2000;
			plane3.y = 1800;
			plane3.x = -2000;
			
			__light.y = 5000;
			
			
			
			__sphere.y = -500;
			
			__camera.rotationX = -30;
			__camera.z = -3000;
			
			
			__worldGroup = new DisplayObject3D();
			
			__scene.addChild(__plane);
			__scene.addChild(plane2);
			__scene.addChild(plane3);
			__scene.addChild(__sphere);
			__scene.addChild(__light);
			
		}
		
		
		protected function moveCamera(_x:int, _z:int):void {
			__camera.x += (_x * __moveAmount);
			__camera.z += (_z * __moveAmount);
		}
		
		protected function adjustCameraFocus(_amount:int):void {
			__camera.focus += _amount;
			dtrace("FOCUS " + __camera.focus);
		}
		protected function adjustCameraZoom(_amount:int):void {
			__camera.zoom += _amount;
			dtrace("ZOOM " + __camera.zoom);
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
				__sphere.yaw(0.1);
				__plane.pitch(-1);
				__renderer.renderScene(__scene, __camera, __viewport);
			}
		}

	}
}
