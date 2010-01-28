package com.breaktrycatch.needmorehumans.control.physics;

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
	private Vec2 _gravity;
	private AABB _worldAABB;
	private float _physScale;
	
	private ArrayList<DisplayObject> _sprites;
	private boolean _wakeOnNextTick = false;
	
	
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight) 
	{
		this(screenWidth, screenHeight, 0.01f);
	}
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight, float physScale) 
	{
		_physScale = physScale;
	}
	
	public void enableDebugDraw(PApplet app)
	{
		_debugDraw = new ProcessingDebugDraw(app);
		_debugDraw.setCamera(0, 0, _physScale);
		_world.setDebugDraw(_debugDraw);
	}

}
