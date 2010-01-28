package com.breaktrycatch.needmorehumans.control.physics;

import java.awt.Point;
import java.util.ArrayList;

import org.jbox2d.collision.AABB;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.World;
import org.jbox2d.testbed.ProcessingDebugDraw;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;

public class PhysicsWorldWrapper {

	private final float PHYS_TIMESTEP = 1.0f/60.0f;
	private final int PHYS_ITERATIONS = 10;
	
	
	private World _world;
	private ProcessingDebugDraw _debugDraw;
	private Vec2 _gravity = new Vec2(0.0f, -10.0f);
	private AABB _worldAABB;
	private float _physScale;
	private Point _physHalfSize;
	
	private ArrayList<DisplayObject> _sprites;
	private boolean _wakeOnNextTick = false;
	
	
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight) 
	{
		this(screenWidth, screenHeight, 0.01f);
	}
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight, float physScale) 
	{
		_physScale = physScale;
		
		float halfWidthBound = screenWidth/2.0f;
		float halfHeightBound = screenHeight/2.0f;
		
		_worldAABB = new AABB();
//		_worldAABB.lowerBound = new Vec2(halfWidthBound * _physScale, )
//		
//		
//		_world = new World(_worldAABB, _gravity, true);
	}
	
//	public Vec2 screenToWorld(Vec2 screenSize)
//	{
//		return screenSize.mul(_physScale);
//	}
//	
//	public Vec2 worldToScreen(Vec2 worldSize)
//	{
//		return worldSize.mul(1/_physScale);
//	}
//	
//	public Vec2 screenToWorld(float screenX, float screenY)
//	{
//		return new Vec2(screenX, screenY).mulLocal(_physScale);
//	}
//	
//	public Vec2 worldToScreen(float screenX, float screenY)
//	{
//		return new Vec2(screenX, screenY).mulLocal(1/_physScale);
//	}
//	
//	public float screenToWorld(float screenSize)
//	{
//		return screenSize * _physScale;
//	}
//	
//	public float worldToScreen(float worldSize)
//	{
//		return worldSize * (1/_physScale);
//	}
	
	
	// ******** DEBUG *************//
	public void enableDebugDraw(PApplet app)
	{
		_debugDraw = new ProcessingDebugDraw(app);
		_debugDraw.setCamera(0, 0, _physScale);
		
		_world.setDebugDraw(_debugDraw);
	}
	
	public void disableDebugDraw()
	{
		_world.setDebugDraw(null);
		_debugDraw = null;
	}

}
