package com.breaktrycatch.needmorehumans.control.physics;

import java.util.ArrayList;

import org.jbox2d.collision.AABB;
import org.jbox2d.collision.CircleDef;
import org.jbox2d.collision.PolygonDef;
import org.jbox2d.collision.ShapeDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.BodyDef;
import org.jbox2d.dynamics.World;
import org.jbox2d.p5.PhysicsUtils;
import org.jbox2d.testbed.ProcessingDebugDraw;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;

public class PhysicsWorldWrapper {

	private final float PHYS_TIMESTEP = 1.0f/60.0f;
	private final int PHYS_ITERATIONS = 10;
	
	
	private World _world;
	private ProcessingDebugDraw _debugDraw;
	private Vec2 _gravity = new Vec2(0.0f, -10.0f);
	private AABB _worldAABB;
	private float _physScale;
	private Vec2 _physHalfSize;
	
	private ArrayList<DisplayObject> _sprites;
	private boolean _wakeAllOnNextTick = false;
	
	
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight) 
	{
		this(screenWidth, screenHeight, 0.01f);
	}
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight, float physScale) 
	{
		_physScale = physScale;
		
		_physHalfSize = new Vec2(screenWidth/2.0f, screenHeight/2.0f);
		
		float worldBoundX = (_physHalfSize.x + 250) * _physScale;
		float worldBoundY = (_physHalfSize.y + 250) * _physScale;
		
		_worldAABB = new AABB();
		_worldAABB.lowerBound = new Vec2(-worldBoundX, -worldBoundY);
		_worldAABB.upperBound = new Vec2(worldBoundX, worldBoundY);
		
		
		_world = new World(_worldAABB, _gravity, true);
	}
	
	public void step()
	{
		_world.step(PHYS_TIMESTEP, PHYS_ITERATIONS);
		
		for (Body body = _world.getBodyList(); body != null; body = body.getNext())
		{
			if(body.isSleeping())
			{
				if(_wakeAllOnNextTick)
					body.wakeUp();
				else
					continue;
			}
			
			
			DisplayObject actor = (DisplayObject)body.getUserData();
			if(actor != null)
			{
				Vec2 pos = worldToScreen(body.getPosition());
				actor.x = (int)pos.x;
				actor.y = (int)pos.y;
				actor.rotation = PhysicsUtils.radToDeg(body.getAngle());
				//trace(body.GetPosition().y, pos.y);
			}
			
		}
			
	}
	
	
	/**
	 * Create a hollow box of the given screen dimensions.
	 * @param centerX Center of box x coordinate (in screen coordinates)
	 * @param centerY Center of box y coordinate (in screen coordinates)
	 * @param width Width of box (screen scale)
	 * @param height Height of box (screen scale)
	 * @param thickness Thickness of box edge (screen scale)
	 * @return
	 */
	public Body[] createHollowBox(float centerX, float centerY, float width, float height, float thickness, PhysicsShapeDefVO settings) {
		Body[] result = new Body[4];
		result[0] = createRect(centerX - width*.5f - thickness*.5f, centerY - height*.5f - thickness*.5f,
				   			   centerX - width*.5f + thickness*.5f, centerY + height*.5f + thickness*.5f, settings);
		result[1] = createRect(centerX + width*.5f - thickness*.5f, centerY - height*.5f - thickness*.5f,
				   			   centerX + width*.5f + thickness*.5f, centerY + height*.5f + thickness*.5f, settings);
		result[2] = createRect(centerX - width*.5f - thickness*.5f, centerY + height*.5f - thickness*.5f,
				   			   centerX + width*.5f + thickness*.5f, centerY + height*.5f + thickness*.5f, settings);
		result[3] = createRect(centerX - width*.5f - thickness*.5f, centerY - height*.5f - thickness*.5f,
				   			   centerX + width*.5f + thickness*.5f, centerY - height*.5f + thickness*.5f, settings);
		return result;
	}
	
	/**
	 * Create a rectangle given by screen coordinates of corners.
	 * @param x0
	 * @param y0
	 * @param x1
	 * @param y1
	 * @return
	 */
	public Body createRect(float x0, float y0, float x1, float y1, PhysicsShapeDefVO settings) {
		float cxs = (x0 + x1) * .5f;
		float cys = (y0 + y1) * .5f;
		float wxs = Math.abs(x1-x0);
		float wys = Math.abs(y1-y0);
		//System.out.println("Screen: ("+cxs + ","+cys+")");
		Vec2 center = screenToWorld(_physHalfSize);
		//System.out.println("World: "+center);
		//float halfWidthWorld = .5f*m_draw.screenToWorld(wxs);
		//float halfHeightWorld = .5f*m_draw.screenToWorld(wys);
		//System.out.println("Half Width world: "+halfWidthWorld);
		
		PolygonDef pd = new PolygonDef();
		//pd.setAsBox(halfWidthWorld, halfHeightWorld);
		setShapeDefProperties(pd, settings);
		
		
		BodyDef bd = new BodyDef();
		setBodyDefProperties(bd);
		
		Body b = _world.createBody(bd);
		b.createShape(pd);
		if (pd.density > 0.0f) b.setMassFromShapes();
		
		b.setXForm(center, 0.0f);
		
		return b;
	}
	
	
	
	/**
	 * Create a circle in screen coordinates
	 * @param x
	 * @param y
	 * @param r
	 * @return
	 */
//	public Body createCircle(float x, float y, float r) {
//		Vec2 center = m_draw.screenToWorld(x,y);
//		//float rad = m_draw.screenToWorld(r);
//		
//		CircleDef cd = new CircleDef();
//		//cd.radius = rad;
//		setShapeDefProperties(cd);
//		
//		BodyDef bd = new BodyDef();
//		setBodyDefProperties(bd);
//		
//		Body b = m_world.createBody(bd);
//		b.createShape(cd);
//		if (m_density > 0.0f) b.setMassFromShapes();
//		
//		b.setXForm(center, 0.0f);
//		
//		return b;
//	}
	
	private void setShapeDefProperties(ShapeDef shape, PhysicsShapeDefVO vo)
	{
		shape.density = vo.density;
		shape.friction = vo.friction;
		shape.restitution = vo.restitution;
		shape.isSensor = vo.isSensor;
	}
	
	private void setBodyDefProperties(BodyDef bd) {
		bd.isBullet = false;
	}
	
	public Vec2 screenToWorld(Vec2 screenSize)
	{
		return screenSize.sub(_physHalfSize).mulLocal(_physScale);
	}
	
	public Vec2 worldToScreen(Vec2 worldSize)
	{
		return worldSize.mul(1/_physScale).addLocal(_physHalfSize);
	}
	
	public Vec2 screenToWorld(float screenX, float screenY)
	{
		return new Vec2(screenX, screenY).subLocal(_physHalfSize).mulLocal(_physScale);
	}
	
	public Vec2 worldToScreen(float screenX, float screenY)
	{
		return new Vec2(screenX, screenY).mulLocal(1/_physScale).addLocal(_physHalfSize);
	}
	
	//DO NOT USE
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
	
	public void destroy()
	{
		
	}

}
