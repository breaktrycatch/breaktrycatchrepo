package com.breaktrycatch.needmorehumans.control.physics;

import java.util.ArrayList;

import org.jbox2d.collision.AABB;
import org.jbox2d.collision.PolygonDef;
import org.jbox2d.collision.ShapeDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.BodyDef;
import org.jbox2d.dynamics.DebugDraw;
import org.jbox2d.dynamics.World;
import org.jbox2d.testbed.ProcessingDebugDraw;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.model.PolyVO;

public class PhysicsWorldWrapper {

	private final float PHYS_TIMESTEP = 1.0f/60.0f;
	private final int PHYS_ITERATIONS = 10;
	
	
	private World _world;
	private ProcessingDebugDraw _debugDraw;
	private Vec2 _gravity = new Vec2(0.0f, -10.0f);
	private AABB _worldAABB;
	private float _physScale;
	private Vec2 _screenHalfSize;
	private boolean _wakeAllOnNextTick = false;
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight) 
	{
		this(screenWidth, screenHeight, 0.01f);
	}
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight, float physScale) 
	{
		_physScale = physScale;
		
		_screenHalfSize = new Vec2(screenWidth/2.0f, screenHeight/2.0f);
		
		float worldBoundX = (_screenHalfSize.x + 150) * _physScale;
		float worldBoundY = (_screenHalfSize.y + 150) * _physScale;
//		float worldBoundX = (_physHalfSize.x + 0) * _physScale;
//		float worldBoundY = (_physHalfSize.y + 0) * _physScale;
//		System.out.println("WORLD HALF SIZE: " + _screenHalfSize);
		_worldAABB = new AABB();
		_worldAABB.lowerBound = new Vec2(-worldBoundX, -worldBoundY);
		_worldAABB.upperBound = new Vec2(worldBoundX, worldBoundY);
		
		System.out.println(_worldAABB.lowerBound);
		System.out.println(_worldAABB.upperBound);
		
		_world = new World(_worldAABB, _gravity, true);
		
	}
	
	public void step()
	{
//		_world.setWarmStarting(false);
//		_world.setPositionCorrection(false);
//		_world.setContinuousPhysics(false);
		
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
				
				//TODO: THIS IS A TEMP HACK TO GET THE IMAGE TO ROUGHLY LINE UP WITH THE PHYSICS DATA
				//THis will be fixed once we have proper alignment of the polydata
				pos.x -= (actor.width/2.0f);
				pos.y -= (actor.height/2.0f);
				
				actor.x = (int)pos.x;
				actor.y = (int)pos.y;
				actor.rotationRad = -body.getAngle();
			}
			
		}
		

		
//		_world.drawDebugData();
			
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
		float wxs = Math.abs(x1-x0) * .5f;
		float wys = Math.abs(y1-y0) * .5f;
		//System.out.println("Screen: ("+cxs + ","+cys+")");
		Vec2 center = screenToWorld(cxs, cys);
//		Vec2 center = screenToWorld(x0, y0);
//		Vec2 center  = _debugDraw.screenToWorld(cxs, cys);
//		System.out.println("Box World Pos: "+center);
//		System.out.println("Half Width world: "+halfWidthWorld);
		
		PolygonDef pd = new PolygonDef();
		pd.setAsBox(wxs * _physScale, wys * _physScale);
		setShapeDefProperties(pd, settings);
		
		
		Body b = createNewBody();
		b.createShape(pd);
		if (pd.density > 0.0f) b.setMassFromShapes();
		
		b.setXForm(center, 0.0f);
		
		return b;
	}
	
	public Body createPolyHuman(ArrayList<PolyVO> data, PhysicsShapeDefVO settings, float screenX, float screenY, float radRotation)
	{
		Body body = createNewBody();
		
		for (PolyVO vo : data) {
			body.createShape(createPolyDefFromVo(vo, settings));
		}
		
		if (settings.density > 0.0f) body.setMassFromShapes();
		
		PApplet.println("Calculating screenToWorld: " + screenX + " : " + screenY + " -> " + screenToWorld(screenX, screenY));
		body.setXForm(screenToWorld(screenX, screenY), radRotation);
		
		return body;
	}
	
	private PolygonDef createPolyDefFromVo(PolyVO vo, PhysicsShapeDefVO settings)
	{
		PolygonDef polyDef = new PolygonDef();
		setShapeDefProperties(polyDef, settings);
		
		for(int i = 0; i < vo.getCapacity(); i++)
		{
			Vec2 vert = vo.getVertex(i).mul(_physScale);
			vert.y *= -1.0f;
			polyDef.addVertex(vert);
		}
		
		return polyDef;
	}
	
	private Body createNewBody()
	{
		BodyDef bd = new BodyDef();
		setBodyDefProperties(bd);
		
		return _world.createBody(bd);
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
	
	public Vec2 screenToWorld(Vec2 screenPos)
	{
		Vec2 worldPos = screenPos.sub(_screenHalfSize).mulLocal(_physScale);
		worldPos.y *= -1.0f;
		return worldPos;
	}
	
	public Vec2 worldToScreen(Vec2 worldPos)
	{
		worldPos.y *= -1;
		Vec2 screenPos = worldPos.mul(1/_physScale).addLocal(_screenHalfSize);
		return screenPos;
	}
	
	public Vec2 screenToWorld(float screenX, float screenY)
	{
		Vec2 worldPos = new Vec2(screenX, screenY).subLocal(_screenHalfSize).mulLocal(_physScale);
		worldPos.y *= -1;
		return worldPos;
	}
	
	public Vec2 worldToScreen(float worldX, float worldY)
	{
		worldY *= -1;
		Vec2 screenPos = new Vec2(worldX, worldY).mulLocal(1/_physScale).addLocal(_screenHalfSize);
		return screenPos;
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
		
		_debugDraw.appendFlags(DebugDraw.e_shapeBit);
		_debugDraw.appendFlags(DebugDraw.e_jointBit);
		_debugDraw.appendFlags(DebugDraw.e_coreShapeBit);
//		_debugDraw.appendFlags(DebugDraw.e_aabbBit);
//		_debugDraw.appendFlags(DebugDraw.e_obbBit);
		_debugDraw.appendFlags(DebugDraw.e_pairBit);
		_debugDraw.appendFlags(DebugDraw.e_centerOfMassBit);

//		_debugDraw.setCamera(_screenHalfSize.x * _physScale ,0 , 1/_physScale);
		_debugDraw.setCamera(0 ,0 , 1/_physScale);
		
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
