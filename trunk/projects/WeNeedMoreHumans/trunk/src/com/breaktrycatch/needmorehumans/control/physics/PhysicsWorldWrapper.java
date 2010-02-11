package com.breaktrycatch.needmorehumans.control.physics;

import java.awt.Rectangle;
import java.util.ArrayList;

import org.jbox2d.collision.AABB;
import org.jbox2d.collision.ContactID;
import org.jbox2d.collision.PolygonDef;
import org.jbox2d.collision.ShapeDef;
import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;
import org.jbox2d.dynamics.BodyDef;
import org.jbox2d.dynamics.DebugDraw;
import org.jbox2d.dynamics.World;
import org.jbox2d.dynamics.contacts.ContactPoint;
import org.jbox2d.dynamics.joints.Joint;
import org.jbox2d.dynamics.joints.JointEdge;
import org.jbox2d.dynamics.joints.RevoluteJointDef;
import org.jbox2d.testbed.ProcessingDebugDraw;

import processing.core.PApplet;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.model.PolyVO;
import com.breaktrycatch.needmorehumans.utils.LogRepository;
import com.breaktrycatch.needmorehumans.utils.PhysicsUtils;

public class PhysicsWorldWrapper {

	private final float PHYS_TIMESTEP = 1.0f/60.0f;
	private final int PHYS_ITERATIONS = 10;	
	
	private final int SHARED_JOINTS_PER_BODY_PAIR = 2;
	private final float MIN_JOINT_SEPARATION = (float)Math.pow(0.2f, 2);
	private final float JOINT_HALF_LENGTH = 0.025f;
	
	
	private World _world;
	private ProcessingDebugDraw _debugDraw;
	private Vec2 _gravity = new Vec2(0.0f, -10.0f);
	private AABB _worldAABB;
	private float _physScale;
	private Vec2 _screenHalfSize;
	private boolean _wakeAllOnNextTick = false;
	private ArrayList<ContactPoint> _reportedHumanHumanContacts = new ArrayList<ContactPoint>();
	private ArrayList<ContactPoint> _reportedHumanBreakerContacts = new ArrayList<ContactPoint>();
	private Body _activeHuman;
	private Rectangle _towerRect;
	
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight) 
	{
		this(screenWidth, screenHeight, 0.01f);
	}
	
	public PhysicsWorldWrapper(float screenWidth, float screenHeight, float physScale) 
	{
		_towerRect = new Rectangle();
		_physScale = physScale;
		
		_screenHalfSize = new Vec2(screenWidth/2.0f, screenHeight/2.0f);
		
		float worldBoundX = (_screenHalfSize.x + 150) * _physScale;
		float worldBoundY = (_screenHalfSize.y + 150) * _physScale;
		
		_worldAABB = new AABB();
		_worldAABB.lowerBound = new Vec2(-worldBoundX, -worldBoundY);
		_worldAABB.upperBound = new Vec2(worldBoundX, worldBoundY);
		
		System.out.println(_worldAABB.lowerBound);
		System.out.println(_worldAABB.upperBound);
		
		_world = new World(_worldAABB, _gravity, true);
		
		_world.setContactListener(new HumanContactListener(this));
	}
	
	public void step()
	{
//		_world.setWarmStarting(false);

//		_world.setContinuousPhysics(true);
//		_towerTopY = Integer.MAX_VALUE;
		
		//MUST BE SET TO FALSE...OTHERWISE ITS ALWAYS TRYING TO CORRECT BODIES WITH 1+ JOINTS
		_world.setPositionCorrection(false);

		_towerRect = null;
		_world.step(PHYS_TIMESTEP, PHYS_ITERATIONS);
				
		for (Body body = _world.getBodyList(); body != null; body = body.getNext())
		{
			//DEBUG - Draw currently existing joints
			PhysicsControl.DEBUG_APP.fill(0xFFFFFF00);
			for (JointEdge joint = body.getJointList(); joint != null; joint = joint.next)
			{
				Vec2 anc1 = worldToScreen(joint.joint.getAnchor1());
				Vec2 anc2 = worldToScreen(joint.joint.getAnchor2());
				
				PhysicsControl.DEBUG_APP.ellipse(anc1.x, anc1.y, 10, 10);
				PhysicsControl.DEBUG_APP.ellipse(anc2.x, anc2.y, 10, 10);
			}
			//END DEBUG
			
			
			Vec2 screenPos = worldToScreen(body.getPosition());
			DisplayObject actor = null;
			if(body.getUserData() instanceof PhysicsUserDataVO)
			{
				actor = ((PhysicsUserDataVO)body.getUserData()).display;
				if(actor != null)
				{
					//affectVisual(actor, screenPos, body.getAngle());
					
					PhysicsUserDataVO userData = (PhysicsUserDataVO)body.getUserData();
					if(userData.isHuman && userData.hasContacted)
					{
						float c = (float)Math.abs(Math.cos(body.getAngle()));
						float s = (float)Math.abs(Math.sin(body.getAngle()));					
						float x_radius = (actor.width * c + actor.height * s)/2.0f;
						float y_radius = (actor.width * s + actor.height * c)/2.0f;
						Vec2 min = new Vec2(screenPos.x - x_radius, screenPos.y - y_radius);
						Rectangle bounds = new Rectangle((int)min.x, (int)min.y, (int)x_radius*2, (int)y_radius*2);						

						// DEBUG
//						Vec2 max = new Vec2(screenPos.x + x_radius, screenPos.y + y_radius);
//						PhysicsControl.DEBUG_APP.stroke(0xFFFF00FF);
//						PhysicsControl.DEBUG_APP.line(min.x, min.y, max.x, min.y);
//						PhysicsControl.DEBUG_APP.line(max.x, min.y, max.x, max.y);
//						PhysicsControl.DEBUG_APP.line(max.x, max.y, min.x, max.y);
//						PhysicsControl.DEBUG_APP.line(min.x, max.y, min.x, min.y);
						// END DEBUG
						
						_towerRect = (_towerRect == null) ? bounds : _towerRect.union(bounds);
					}
				}				
			}
			else if(body.getUserData() instanceof DisplayObject)
			{
				actor = (DisplayObject)body.getUserData();
			}
			
			if(body.isSleeping())
			{
				if(_wakeAllOnNextTick)
					body.wakeUp();
				else
					continue;
			}
			else if(actor != null)
			{
				affectVisual(actor, screenPos, body.getAngle());
			}
		}
		
		if(_towerRect == null)
		{
			_towerRect = new Rectangle();
		}
		
		processHumanToHumanContacts();
		_reportedHumanHumanContacts.clear();
		//processHumanToBreakerContacts();
		_reportedHumanBreakerContacts.clear();
		
//		_world.drawDebugData();
	}
	
	private void affectVisual(DisplayObject actor, Vec2 screenPosition, float rotation)
	{
		Vec2 pos = screenPosition.clone();
		pos.x -= (actor.width/2.0f);
		pos.y -= (actor.height/2.0f);
		
		actor.x = (int)pos.x;
		actor.y = (int)pos.y;
		actor.rotationRad = -rotation;
	}
	
	private void processHumanToHumanContacts()
	{
		//Track Dups
		ArrayList<ContactID> handledContacts = new ArrayList<ContactID>();
		
		ContactLoop : for(int i=0; i<_reportedHumanHumanContacts.size(); i++)
		{
			ContactPoint contact = _reportedHumanHumanContacts.get(i);
			
			//Check if this contact has already been eval'd
			if(containsDupElement(handledContacts, contact.id)){ continue;	}
			handledContacts.add(contact.id);
			
			
			Body body1 = contact.shape1.getBody();
			Body body2 = contact.shape2.getBody();
			
			//Check to see if the two extremities already share too many a joints
			int sharedJointCount = 0;
			
			for (JointEdge joint = body1.getJointList(); joint != null; joint = joint.next)
			{
				if(joint.other.equals(body2))
				{
					sharedJointCount++;
					
					if(sharedJointCount >= SHARED_JOINTS_PER_BODY_PAIR)
					{
						//LogRepository.getInstance().getMikesLogger().info("Bodies share to many joints already!");
						continue ContactLoop;
					}
					
					if(Math.abs(PhysicsUtils.distanceSQD(joint.joint.getAnchor1(), contact.position)) <= MIN_JOINT_SEPARATION)
					{
						//LogRepository.getInstance().getMikesLogger().info("Contact too close to a joint: " + joint);
						continue ContactLoop;
					}
//					Math.abs(PhysicsUtils.distanceSQD(joint.joint.getAnchor2(), contact.position)) <= MIN_JOINT_SEPARATION
				}
			}
			
			
			//TODO: TEST TO SEE WHICH JOINT CONFIG IS GENERALLY FASTER
			//Create a joint between the two objects
			//Vec2 jointVectorHalfLength = contact.normal.mul(JOINT_HALF_LENGTH);
//			DistanceJointDef jd = new DistanceJointDef();
//			jd.collideConnected = true;
//			jd.dampingRatio = 0.5f;
//			jd.initialize(contact.shape1.getBody(), contact.shape2.getBody(), contact.position.sub(jointVectorHalfLength), contact.position.add(jointVectorHalfLength));
			
			//Revolute joint may be faster than distance...who knows?
			RevoluteJointDef jd = new RevoluteJointDef();
			jd.collideConnected = true;
			jd.initialize(body1, body2, contact.position);
			
			//Simulate friction, may or may not increase performace through limiting movement
//			jd.maxMotorTorque = 10.0f;
//			jd.enableMotor = true;
			
			Joint joint = _world.createJoint(jd);
			
			
			LogRepository.getInstance().getMikesLogger().info("JOINT CREATED! " + joint);
			//break;
		}
	}
	
	private void processHumanToBreakerContacts()
	{
		//TODO: Implement/TEST this later

//		//Track Dups
//		ArrayList<ContactID> handledContacts = new ArrayList<ContactID>();
//		
//
//		for(int i=0; i<_reportedHumanBreakerContacts.size(); i++)
//		{
//			ContactPoint contact = _reportedHumanHumanContacts.get(i);
//			
//			//Check if this contact has already been eval'd
//			if(containsDupElement(handledContacts, contact.id)){ continue;	}
//			handledContacts.add(contact.id);
//			
//			Body body1 = contact.shape1.getBody();
//			Body body2 = contact.shape2.getBody();
//			PhysicsUserDataVO data1 = (PhysicsUserDataVO)body1.getUserData();
//			PhysicsUserDataVO data2 = (PhysicsUserDataVO)body2.getUserData();
//			
//			if(data1.breaksHumanJoints)
//			{
//				detatchBody(body2);
//			}
//			else if(data2.breaksHumanJoints)
//			{
//				detatchBody(body1);
//			}
//		}
	}
	
	//Breaks all joints on a body
	private void detatchBody(Body body)
	{
		for (JointEdge joint = body.getJointList(); joint != null; joint = joint.next)
		{
			_world.destroyJoint(joint.joint);
		}
	}
	
	private boolean containsDupElement(ArrayList<ContactID> handledList, ContactID id)
	{
		for (ContactID contactID : handledList) {
			if(contactID.isEqual(id))
			{
				return true;
			}
		}
		
		return false;
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
		
		//PApplet.println("Calculating screenToWorld: " + screenX + " : " + screenY + " -> " + screenToWorld(screenX, screenY));
		body.setXForm(screenToWorld(screenX, screenY), radRotation);
		
		_activeHuman = body;
		
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
	
	public Body getActiveHuman()
	{
		return _activeHuman;
	}
	
	public void reportHumanHumanContact(ContactPoint contact)
	{
		_reportedHumanHumanContacts.add(contact);
	}
	
	public void reportHumanBreakerContact(ContactPoint contact)
	{
		_reportedHumanBreakerContacts.add(contact);
	}
	
	public float getPhysScale()
	{
		return _physScale;
	}
	
//	public int getTowerTopY()
//	{
//		return _towerTopY;
//	}
	
	public Rectangle getTowerRect()
	{
		return _towerRect;
	}
	
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

		_debugDraw.setCamera(-8.39f ,23.25f , 1/_physScale);
//		_debugDraw.setCamera(0 ,0 , 1/_physScale);
		
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
